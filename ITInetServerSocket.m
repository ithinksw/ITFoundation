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

@interface ITInetServerSocket(Private)
-(void)setupConnectionWithServiceName:(NSString*)name;
-(void)setupConnectionWithPortNumber:(NSNumber*)port;
-(void)setupRendezvousAdvertising:(NSString*)name;
-(void)setupTimer;
-(void)timerFunc:(NSTimer*)timer;
@end

@implementation ITInetServerSocket
- (id)init
{
    if (self = [super init])
	   {
	   sockfd = 0;
	   delegate = clients = nil;
	   }
    return self;
}

- (id)initWithServiceName:(NSString*)name delegate:(id)d
{
    if (self = [super init])
	   {
	   delegate = [d retain];
	   clients = [[NSMutableSet alloc] init];
	   [self setupConnectionWithServiceName:name];
	   }
    return self;
}

- (id)initWithPort:(NSNumber*)port rendezvousName:(NSString*)name delegate:(id)d
{
    if (self = [super init])
	   {
	   delegate = [d retain];
	   clients = [[NSMutableSet alloc] init];
	   [self setupConnectionWithPortNumber:port];
	   }
    return self;
}

- (void)dealloc
{
    [service stop];
    [service release];
    [clients release];
    [delegate release];
    shutdown(sockfd,2);
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
@end

@implementation ITInetServerSocket(Private)
-(void)setupConnectionWithServiceName:(NSString*)name
{
    const char *_name = [name cString];
    struct addrinfo hints,*res;

    hints.ai_flags = AI_PASSIVE;
    hints.ai_family = PF_INET;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    hints.ai_addrlen = 0;
    hints.ai_canonname = NULL;
    hints.ai_addr = NULL;
    hints.ai_next = NULL;

    getaddrinfo(NULL,_name,&hints,&res);
    sockfd = socket(res->ai_family, res->ai_socktype,res->ai_protocol);
    bind(sockfd, res->ai_addr, res->ai_addrlen);
    listen(sockfd, SOMAXCONN);
    fcntl(sockfd,F_SETFL,O_NONBLOCK);
    freeaddrinfo(res);
}

-(void)setupConnectionWithPortNumber:(NSNumber*)port
{
    short _port = [port shortValue];
    struct sockaddr_in sa;

    sockfd = socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);
    sa.sin_addr.s_addr = INADDR_ANY;
    sa.sin_family = AF_INET;
    sa.sin_port = htons(_port);
    bind(sockfd,(struct sockaddr *)&sa,sizeof(sa));
    listen(sockfd, SOMAXCONN);
    fcntl(sockfd,F_SETFL,O_NONBLOCK);
}

- (void)setupRendezvousAdvertising:(NSString*)name port:(NSNumber*)port
{
    service = [[NSNetService alloc] initWithDomain:@"" type:[NSString stringWithFormat:@"_%@._tcp.",name] port:htons([port shortValue])];
    [service publish];
}

- (void)setupTimer
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:0 target:self selector:@selector(timerFunc:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)timerFunc:(NSTimer*)timer
{
    struct sockaddr_in csa;
    int csalen;
    signed int cfd;
    (void) timer;
    cfd = accept(sockfd,(struct sockaddr*)&csa,&csalen);
    if (cfd == -1) {
	   if (errno == EWOULDBLOCK) return;
	   else {perror("Too bad I haven't implemented error checking yet");}
	   }
	   else {
		   ITInetSocket *csocket = [[[ITInetSocket alloc] initWithFD:cfd delegate:self] autorelease];
		   [clients addObject:csocket];
		   [delegate newClientJoined:csocket];
		   
	   }
}
@end