//
//  ITInetSocket.m
//  ITFoundation
//
//  Created by Alexander Strange on Tue Feb 11 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "ITInetSocket.h"
#import "ITServiceBrowserDelegate.h"
#import <sys/socket.h>
#import <arpa/inet.h>
#import <unistd.h>

@interface ITInetSocket(Debugging)
-(NSString*)dumpv6Addrinfo:(struct addrinfo *)_ai;
@end

@interface ITInetSocket(Private)
-(void)doConnSetupWithHost:(NSString*)host namedPort:(NSString*)namedPort;
-(void)realDoConnection;
-(void)spinoffReadLoop;
-(void)socketReadLoop:(id)data;
@end

@implementation ITInetSocket
+(void)startAutoconnectingToService:(NSString*)type delegate:(id <ITInetSocketDelegate,NSObject>)d
{
    NSNetServiceBrowser *browse = [[NSNetServiceBrowser alloc] init];
    ITServiceBrowserDelegate *bd = [[ITServiceBrowserDelegate alloc] initWithDelegate:d];

    [browse setDelegate:bd];
    [browse searchForServicesOfType:[NSString stringWithFormat:@"._%@._tcp",type] inDomain:nil];
}

-(id)initWithFD:(int)fd delegate:(id <ITInetSocketDelegate,NSObject>)d
{
    if (self = [super init])
	   {
	   state = ITInetSocketListening;
	   sockfd = fd;
	   delegate = [d retain];
	   port = 0;
	   writePipe = [[ITByteStream alloc] initWithDelegate:self];
	   readPipe = [[ITByteStream alloc] initWithDelegate:d];
	   ai = nil;
	   sarr = nil;
	   bufs = 512;
	   actionflag = dieflag = 0;
	   }
    return self;
}

-(id)initWithDelegate:(id <ITInetSocketDelegate,NSObject>)d
{
    if (self = [super init])
	   {
	   state = ITInetSocketDisconnected;
	   sockfd = -1;
	   delegate = [d retain];
	   port = 0;
	   writePipe = [[ITByteStream alloc] initWithDelegate:self];
	   readPipe = [[ITByteStream alloc] initWithDelegate:d];
	   ai = nil;
	   sarr = nil;
	   bufs = 512;
	   actionflag = dieflag = 0;
	   }
    return self;
}


-(void) dealloc
{
    shutdown(sockfd,2);
    [delegate release];
    [writePipe release];
    [readPipe release];
    if (!sarr) freeaddrinfo(ai);
    [sarr release];
}

-(void) connectToHost:(NSString*)host onPort:(short)thePort
{
    if (state == ITInetSocketDisconnected)
	   {
	   NSString *nport = [[NSNumber numberWithShort:thePort] stringValue];
	   [self doConnSetupWithHost:host namedPort:nport];
	   }
}

-(void) connectToHost:(NSString*)host onNamedPort:(NSString*)_port
{
    if (state == ITInetSocketDisconnected)
	   {
	   [self doConnSetupWithHost:host namedPort:_port];
	   }
}

-(void) connectWithSockaddrArray:(NSArray*)arr
{
    if (state == ITInetSocketDisconnected)
	   {
	   NSEnumerator *e = [arr objectEnumerator];
	   NSData *d;
	   struct addrinfo *a;
	   ai = malloc(sizeof(struct addrinfo));
	   a = ai;
	   while (d = [e nextObject])
	   {
		  struct sockaddr *s = (struct sockaddr*)[d bytes];
		  a->ai_family = s->sa_family;
		  a->ai_addr = s;
		  a->ai_next = malloc(sizeof(struct addrinfo));
		  a = a->ai_next;
	   }
	   ai_cur = ai;
	   [self realDoConnection];
	   }
}

-(void)disconnect
{
    NSLog(@"Got a disconnect");
    dieflag = 1;
}

-(void)retryConnection
{
    ai_cur = ai_cur->ai_next?ai_cur->ai_next:ai_cur;
    [self disconnect];
    [self realDoConnection];
}

-(ITInetSocketState)state
{
    return state;
}
-(id <ITInetSocketDelegate>)delegate
{
    return delegate;
}

-(unsigned short)bufferSize
{
    return bufs;
}

-(void)setBufferSize:(unsigned short)_bufs
{
    bufs = _bufs;
}

-(void)newDataAdded:(ITByteStream*)sender
{
    NSLog(@"writePipe got something");
    actionflag = 1;
    do {} while (actionflag == 1);
    NSLog(@"thread saw actionFlag");
}
@end

@implementation ITInetSocket(Debugging)
-(NSString*)dumpv6Addrinfo:(struct addrinfo *)_ai
{
    const char *cfmt =
    "{\n"
    "Flags = %x\n"
    "Family = %x\n"
    "Socktype = %x\n"
    "Protocol = %x\n"
    "Canonname = %s\n"
    "Sockaddr = \n"
    "\t{\n"
    "\tLength = %x\n"
    "\tFamily = %x\n"
    "\tPort = %d\n"
    "\tFlowinfo = %x\n"
    "\tAddr = {%hx:%hx:%hx:%hx:%hx:%hx:%hx:%hx}\n"
    "\tScope = %x\n"
    "\t}\n"
    "Next = %@\n"
    "}\n";
    NSString *nsfmt = [NSString stringWithCString:cfmt];
    struct sockaddr_in6 *sa = (struct sockaddr_in6 *)_ai->ai_addr;
    NSString *buf = [[NSMutableString alloc] initWithFormat:nsfmt,_ai->ai_flags,_ai->ai_family,_ai->ai_socktype,_ai->ai_protocol,_ai->ai_canonname?_ai->ai_canonname:"",sa->sin6_len,sa->sin6_family,sa->sin6_port,sa->sin6_flowinfo,sa->sin6_addr.__u6_addr.__u6_addr16[0],sa->sin6_addr.__u6_addr.__u6_addr16[1],sa->sin6_addr.__u6_addr.__u6_addr16[2],sa->sin6_addr.__u6_addr.__u6_addr16[3],sa->sin6_addr.__u6_addr.__u6_addr16[4],sa->sin6_addr.__u6_addr.__u6_addr16[5],sa->sin6_addr.__u6_addr.__u6_addr16[6],sa->sin6_addr.__u6_addr.__u6_addr16[7],sa->sin6_scope_id,_ai->ai_next?[self dumpv6Addrinfo:_ai->ai_next]:@"nil"];

    return buf;
}
@end

@implementation ITInetSocket(Private)
-(void)doConnSetupWithHost:(NSString*)host namedPort:(NSString*)namedPort
{
    struct addrinfo hints;
	   int err;
	   const char *portNam = [namedPort cString], *hostCStr = [host cString];
	   state = ITInetSocketConnecting;
	   hints.ai_flags = 0;
	   hints.ai_family = PF_UNSPEC;
	   hints.ai_socktype = SOCK_STREAM;
	   hints.ai_protocol = IPPROTO_TCP;
	   hints.ai_addrlen = 0;
	   hints.ai_canonname = NULL;
	   hints.ai_addr = NULL;
	   hints.ai_next = NULL;

	   err = getaddrinfo(hostCStr,portNam,&hints,&ai);

	   NSLog(@"%s, h %@ p %@",gai_strerror(err),host,namedPort);
	   NSLog(ai?[self dumpv6Addrinfo:ai]:@"");
	   ai_cur = ai;
	   [self realDoConnection];
}

-(void)realDoConnection
{
    sockfd = socket(ai_cur->ai_addr->sa_family,SOCK_STREAM,IPPROTO_TCP);
    [self spinoffReadLoop];
}

-(void)spinoffReadLoop
{
    NSPort *p1 = [NSPort port], *p2 = [NSPort port];
    NSConnection *dcon = [[NSConnection alloc] initWithReceivePort:p1 sendPort:p2];
    NSArray *par = [NSArray arrayWithObjects:p2,p1,nil];
    [dcon setRootObject:delegate];
    [NSThread detachNewThreadSelector:@selector(socketReadLoop:) toTarget:self withObject:par]; //spawn read thread
}

-(void)socketReadLoop:(id)data
{
    NSAutoreleasePool *ap = [[NSAutoreleasePool alloc] init];
    NSConnection *dcon = [[NSConnection alloc] initWithReceivePort:[data objectAtIndex:0] sendPort:[data objectAtIndex:1]];
    NSProxy *dp = [[dcon rootProxy] retain];
    char *buf = malloc(bufs);
    unsigned long readLen = 0;
    signed int err;
    [readPipe setDelegate:dp];
    NSLog(@"Connecting");
    err = connect(sockfd,ai_cur->ai_addr,ai_cur->ai_addrlen);
    if (err == -1)
	   {
	   perror("CAwh");
	   [(id)dp errorOccured:ITInetCouldNotConnect during:ITInetSocketConnecting onSocket:self];
	   goto dieaction;
	   }
    NSLog(@"Sending finishedConnecting");
    [(id)dp finishedConnecting:self];
lstart:
	   state = ITInetSocketListening;
	   while (!actionflag && !dieflag)
	   {
		  readLen = recv(sockfd,buf,bufs,0);
		  state = ITInetSocketReading;
		  if (readLen == -1) {[(id)dp errorOccured:ITInetConnectionDropped during:ITInetSocketReading onSocket:self];goto dieaction;}
		  if (readLen) {
			 NSLog(@"recv'd");
			 NSLog(@"Doing writeData to readPipe");
			 [readPipe writeBytes:buf len:readLen];
			 [ap release];
			 ap = [[NSAutoreleasePool alloc] init];
		  }
	   }
	   state = ITInetSocketListening;
    actionflag = 0;

    if (dieflag)
	   {
dieaction:
	   state = ITInetSocketDisconnected;
	   perror("Awh");
	   free(buf);
	   shutdown(sockfd,2);
	   [dcon release];
	   [dp release];
	   [ap release];
	   dieflag = 0;
	   return;
	   }

    {
	   state = ITInetSocketWriting;
	   NSLog(@"Emptying writePipe");
	   NSData *d = [writePipe readAllData];
	   write(sockfd,[d bytes],[d length]);
	   [ap release];
	   ap = [[NSAutoreleasePool alloc] init];
	   goto lstart;
	   }
    goto dieaction;
}
@end