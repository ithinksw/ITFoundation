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
#import <arpa/inet.h>
#import <netinet/in.h>
#import <sys/socket.h>
#import <netdb.h>
#import <fcntl.h>
#import <unistd.h>

/* Too bad Objective-C doesn't have class variables... */
static NSMutableDictionary *servsockets;
static NSTimer *timer;

@interface ITInetServerSocket(Private)
+(void)registerSocket:(ITInetServerSocket*)sock;
+(void)unregisterSocket:(ITInetServerSocket*)sock;
-(short)lookupPortForServiceType:(NSString*)name;
-(void)setupConnection;
-(void)stopConnection;
-(void)setupRendezvousAdvertising;
-(void)stopRendezvousAdvertising;
+(void)setupTimer;
+(void)stopTimer;
+(void)globalTimerFunc:(NSTimer*)timer;
-(BOOL)timerFunc;
@end

@implementation ITInetServerSocket
+ (void)initialize
{
    servsockets = [[NSMutableDictionary alloc] init];
    [self setupTimer];
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
	   rndType = rndName = nil;
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
	   rndType = rndName = nil;
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

- (BOOL)registerSocket
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
    [servsockets setObject:sock forKey:[NSString stringWithFormat:@"%lu",[sock port]]];
}

+(void)unregisterSocket:(ITInetServerSocket*)sock
{
    [sock stopConnection];
    [servsockets removeObjectForKey:[NSString stringWithFormat:@"%lu",[sock port]]];
}

-(short)lookupPortForServiceType:(NSString*)name
{
    const char *_name = [name cString];
    struct addrinfo hints,*res;
    short p;

    hints.ai_flags = AI_PASSIVE;
    hints.ai_family = PF_INET;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    hints.ai_addrlen = 0;
    hints.ai_canonname = NULL;
    hints.ai_addr = NULL;
    hints.ai_next = NULL;

    getaddrinfo(NULL,_name,&hints,&res);
    p = ntohs(((struct sockaddr_in *)res->ai_addr)->sin_port);
    freeaddrinfo(res);
    return p;
}

-(void)setupConnection
{
    struct sockaddr_in sa;

    sockfd = socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);
    sa.sin_addr.s_addr = INADDR_ANY;
    sa.sin_family = AF_INET;
    sa.sin_port = htons(port);
    bind(sockfd,(struct sockaddr *)&sa,sizeof(sa));
    listen(sockfd, SOMAXCONN);
    fcntl(sockfd,F_SETFL,O_NONBLOCK);
    [self setupRendezvousAdvertising];
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
    service = [[NSNetService alloc] initWithDomain:@"" type:[NSString stringWithFormat:@"_%@._tcp.",rndType] name:rndName port:htons(port)];
    [service publish];
}

- (void)stopRendezvousAdvertising
{
    [service stop];
    [service release];
    service = nil;
}

+ (void)setupTimer
{
    if (!timer) timer = [NSTimer timerWithTimeInterval:0 target:self selector:@selector(globalTimerFunc:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

+ (void)stopTimer
{
    [timer invalidate];
    [timer release];
    timer = nil;
}

+ (void)globalTimerFunc:(NSTimer*)timer
{
    NSEnumerator *enume = [servsockets objectEnumerator];
    id obj;

    while (obj = [enume nextObject])
	   {
	   [obj timerFunc];
	   }
}

- (BOOL)timerFunc
{
    if (sockfd != -1)
	   {
	   struct sockaddr_in csa;
	   int csalen;
	   signed int cfd;
	   cfd = accept(sockfd,(struct sockaddr*)&csa,&csalen);
	   if (cfd == -1) {
		  if (errno == EWOULDBLOCK) return NO;
		  else {perror("Too bad I haven't implemented error checking yet");}
	   }
	   else {
		  ITInetSocket *csocket = [[[ITInetSocket alloc] initWithFD:cfd delegate:self] autorelease];
		  [clients addObject:csocket];
		  [delegate newClientJoined:csocket];
		  return YES;
	   }
	   }
    return NO;
}
@end