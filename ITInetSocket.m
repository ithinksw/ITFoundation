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
	   writePipe = [[ITByteStream alloc] init];
	   readPipe = [[ITByteStream alloc] init];
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
	   writePipe = [[ITByteStream alloc] init];
	   readPipe = [[ITByteStream alloc] init];
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
	   }
}

-(void)disconnect
{
}

-(void)retryConnection
{
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
@end

@implementation ITInetSocket(Debugging)
-(NSString*)dumpv6Addrinfo:(struct addrinfo *)_ai
{
    const char *cfmt =
    "\{\n"
    "Flags = %x\n"
    "Family = %x\n"
    "Socktype = %x\n"
    "Protocol = %x\n"
    "Canonname = %s\n"
    "Sockaddr = \n"
    "{\n"
    "\tLength = %x\n"
    "\tFamily = %x\n"
    "\tPort = %d\n"
    "\tFlowinfo = %x\n"
    "\tAddr = {%hx:%hx:%hx:%hx:%hx:%hx:%hx:%hx}\n"
    "\tScope = %x\n"
    "}\n"
    "Next = ";
    NSString *nsfmt = [NSString stringWithCString:cfmt];
    NSMutableString *buf = [[[NSMutableString alloc] init] autorelease];

    do
	   {
		  struct sockaddr_in6 *sa = (struct sockaddr_in6 *)_ai->ai_addr;
		  [buf appendFormat:nsfmt,_ai->ai_flags,_ai->ai_family,_ai->ai_socktype,_ai->ai_protocol,_ai->ai_canonname?_ai->ai_canonname:"",sa->sin6_len,sa->sin6_family,sa->sin6_port,sa->sin6_flowinfo,sa->sin6_addr.__u6_addr.__u6_addr16[0],sa->sin6_addr.__u6_addr.__u6_addr16[1],sa->sin6_addr.__u6_addr.__u6_addr16[2],sa->sin6_addr.__u6_addr.__u6_addr16[3],sa->sin6_addr.__u6_addr.__u6_addr16[4],sa->sin6_addr.__u6_addr.__u6_addr16[5],sa->sin6_addr.__u6_addr.__u6_addr16[6],sa->sin6_addr.__u6_addr.__u6_addr16[7],sa->sin6_scope_id];
	   }
    while (_ai = _ai->ai_next);
    [buf appendString:@"nil\n}"];
    return buf;
}
@end

@implementation ITInetSocket(Private)
-(void)doConnSetupWithHost:(NSString*)host namedPort:(NSString*)namedPort
{
    struct addrinfo hints;
	   int err;
	   const char *portNam = [namedPort cString], *hostCStr = [host cString];

	   hints.ai_flags = 0;
	   hints.ai_family = PF_INET6;
	   hints.ai_socktype = SOCK_STREAM;
	   hints.ai_protocol = IPPROTO_TCP;
	   hints.ai_canonname = NULL;
	   hints.ai_addr = NULL;
	   hints.ai_next = NULL;

	   err = getaddrinfo(hostCStr,portNam,&hints,&ai);
	   if (err == EAI_NODATA) //it's a dotted-decimal IPv4 string, so we use v6compat stuff now
	   {
		  err = getaddrinfo([[NSString stringWithFormat:@"ffff::%s",hostCStr] cString],portNam,&hints,&ai);
	   }
	   NSLog([self dumpv6Addrinfo:ai]);
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
    NSProxy *dp = [dcon rootProxy];
    char *buf = malloc(bufs);
    unsigned long readLen = 0;

lstart:
    do
	   {
		  NSData *d = [NSData alloc];
		  readLen = recv(sockfd,buf,bufs,0);
		  [d initWithBytesNoCopy:buf length:readLen];
		  [readPipe writeData:d];
		  [d release];
		  [dp dataRecieved:self];
	   }
    while (!actionflag);
    actionflag = 0;
    if (dieflag)
	   {
	   free(buf);
	   [dcon release];
	   [ap release];
	   dieflag = 0;
	   return;
	   }

    {
	   NSData *d = [writePipe readAllData];
	   write(sockfd,[d bytes],[d length]);
	   goto lstart;
	   }
}
@end