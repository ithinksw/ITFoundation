//
//  ITInetServerSocket.m
//  ITFoundation
//
//  Created by Alexander Strange on Thu Feb 13 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "ITInetServerSocket.h"
#import "ITInetSocket.h"
#import <sys/types.h>
#import <sys/time.h>
#import <arpa/inet.h>
#import <netinet/in.h>
#import <sys/socket.h>
#import <netdb.h>
#import <fcntl.h>
#import <unistd.h>

/* Too bad Objective-C doesn't have class variables... */
static NSMutableSet *servsockets;

@interface ITInetServerSocket(Private)
+(void)registerSocket:(ITInetServerSocket*)sock;
+(void)unregisterSocket:(ITInetServerSocket*)sock;
-(short)lookupPortForServiceType:(NSString*)name;
-(void)setupConnection;
-(void)stopConnection;
-(void)setupRendezvousAdvertising;
-(void)stopRendezvousAdvertising;
-(void)setupThread;
-(void)stopThread;
-(void)newClient:(int)cfd;
-(void)socketAcceptLoop:(id)data;
@end

@implementation ITInetServerSocket
+ (void)initialize
{
    servsockets = [[NSMutableSet alloc] init];
    //[self setupTimer];
}

- (id)init
{
    if (self = [super init])
	   {
	   sockfd = -1;
	   delegate = nil;
	   clients = [[NSMutableSet alloc] init];
	   service = nil;
	   port = 0;
	   dieflag = 0;
	   rndType = rndName = nil;
	   timer = nil;
	   }
    return self;
}

- (id)initWithDelegate:(id)d
{
    if (self = [super init])
	   {
	   sockfd = -1;
	   delegate = [d retain];
	   clients = [[NSMutableSet alloc] init];
	   service = nil;
	   port = 0;
	   dieflag = 0;
	   rndType = rndName = nil;
	   timer = nil;
	   }
    return self;
}

- (void)dealloc
{
    [self stopConnection];
    [clients release];
    [delegate release];
    [rndName release];
    [rndType release];
}

- (BOOL)start
{
    if (!rndName || !rndType || !port) return NO;
    [ITInetServerSocket registerSocket:self];
    return YES;
}

- (int)sockfd
{
    return sockfd;
}

- (NSSet*)clients
{
    return clients;
}

- (id)delegate
{
    return delegate;
}

- (short)port
{
    return port;
}

- (void)stop
{
    [ITInetServerSocket unregisterSocket:self];
}

- (void)setServiceType:(NSString*)type useForPort:(BOOL)p
{
    rndType = [type retain];
    if (p) {
	   port = [self lookupPortForServiceType:type];
    }
}

- (void)setServiceName:(NSString*)name
{
    rndName = [name retain];
}

- (void)setPort:(short)p
{
    port = p;
}
@end

@implementation ITInetServerSocket(Private)
+(void)registerSocket:(ITInetServerSocket*)sock
{
    [sock setupConnection];
    [servsockets addObject:sock];
}

+(void)unregisterSocket:(ITInetServerSocket*)sock
{
    [sock stopConnection];
    [servsockets removeObject:sock];
}

-(short)lookupPortForServiceType:(NSString*)name
{
    const char *_name = [name cString];
    struct addrinfo *res;
    short p;
    getaddrinfo(NULL,_name,NULL,&res);
    p = ntohs(((struct sockaddr_in *)res->ai_addr)->sin_port);
    freeaddrinfo(res);
    return p;
}

-(void)setupConnection
{
    struct addrinfo hints, *ai;
    hints.ai_flags = AI_PASSIVE;
    hints.ai_family = PF_INET6;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    hints.ai_addrlen = 0;
    hints.ai_canonname = hints.ai_addr = hints.ai_next = NULL;
    getaddrinfo(NULL,[[[NSNumber numberWithShort:port] stringValue] cString],&hints,&ai);
    bind(sockfd,ai->ai_addr,ai->ai_addrlen);
    listen(sockfd, SOMAXCONN);
    freeaddrinfo(ai);
    [self setupRendezvousAdvertising];
    [self setupThread];
}

- (void)stopConnection
{
    [self stopRendezvousAdvertising];
    [clients makeObjectsPerformSelector:@selector(disconnect)];
    shutdown(sockfd,2);
    close(sockfd);
    sockfd = -1;
}

- (void)setupRendezvousAdvertising
{
    NSString *a = [NSString stringWithFormat:@"_%@._tcp.",rndType];
    service = [[NSNetService alloc] initWithDomain:@"" type:a name:rndName port:htons(port)];
    NSLog(@"Advertising a service of type %@ name %@",a,rndName);
    [service publish];
}

- (void)stopRendezvousAdvertising
{
    [service stop];
    [service release];
    service = nil;
}

- (void)setupThread
{
    NSPort *p1 = [NSPort port], *p2 = [NSPort port];
    NSConnection *dcon = [[NSConnection alloc] initWithReceivePort:p1 sendPort:p2];
    NSArray *par = [NSArray arrayWithObjects:p2,p1,nil];
    [dcon setRootObject:self];
    NSLog(@"detached server thread");
    [NSThread detachNewThreadSelector:@selector(socketAcceptLoop:) toTarget:self withObject:par]; 
}

- (void)stopThread
{
    dieflag = 1;
}

- (void)newClient:(int)cfd
{
    ITInetSocket *csocket = [[ITInetSocket alloc] initWithFD:cfd delegate:delegate];
    [clients addObject:csocket];
}

- (void)socketAcceptLoop:(id)data
{
    NSAutoreleasePool *ap = [[NSAutoreleasePool alloc] init];
    NSArray *par = data;
    NSConnection *dcon = [[NSConnection alloc] initWithReceivePort:[par objectAtIndex:0] sendPort:[par objectAtIndex:1]];
    NSProxy *dp = [dcon rootProxy];
    while ((sockfd != -1) && !dieflag)
	   {
	   signed int cfd;
	   cfd = accept(sockfd,NULL,NULL);
	   NSLog(@"Someone connected!");
	   [(id)dp newClient:cfd];
	   }
    dieflag = 0;
    [dcon release];
    [ap release];
}
@end