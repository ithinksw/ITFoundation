//
//  ITInetSocket.m
//  ITFoundation
//
//  Created by Alexander Strange on Tue Feb 11 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "ITInetSocket.h"
#import <sys/socket.h>
#import <arpa/inet.h>

@interface ITInetSocket(Debugging)
-(NSString*)dumpv6Addrinfo:(struct addrinfo *)_ai;
@end

@implementation ITInetSocket
-(id)initWithFD:(int)fd delegate:(id)d
{
    if (self = [super init])
	   {
	   state = ITInetSocketListening;
	   sockfd = fd;
	   delegate = [d retain];
	   port = 0;
	   writeBuffer = nil;
	   ai = nil;
	   }
    return self;
}

-(id)initWithDelegate:(id)d
{
    if (self = [super init])
	   {
	   state = ITInetSocketDisconnected;
	   sockfd = -1;
	   delegate = [d retain];
	   port = 0;
	   writeBuffer = nil;
	   ai = nil;
	   }
    return self;
}

-(void) connectToHost:(NSString*)host onPort:(short)thePort
{
    if (state == ITInetSocketDisconnected)
	   {
	   struct addrinfo hints;
	   int err;
	   const char *portNam = [[[NSNumber numberWithShort:thePort] stringValue] cString], *hostCStr = [host cString];

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
}

-(ITInetSocketState)state
{
    return state;
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
    "\{\n"
    "\tLength = %x\n"
    "\tFamily = %x\n"
    "\tPort = %d\n"
    "\tFlowinfo = %x\n"
    "\tAddr = {%#lx,%#lx,%#lx,%#lx}\n"
    "\tScope = %x\n"
    "\}\n"
    "Next = ";
    NSString *nsfmt = [NSString stringWithCString:cfmt];
    NSMutableString *buf = [[[NSMutableString alloc] init] autorelease];

    do
	   {
		  struct sockaddr_in6 *sa = (struct sockaddr_in6 *)_ai->ai_addr;
		  [buf appendFormat:nsfmt,_ai->ai_flags,_ai->ai_family,_ai->ai_socktype,_ai->ai_protocol,_ai->ai_canonname?_ai->ai_canonname:"",sa->sin6_len,sa->sin6_family,sa->sin6_port,sa->sin6_flowinfo,sa->sin6_addr.__u6_addr.__u6_addr32[0],sa->sin6_addr.__u6_addr.__u6_addr32[1],sa->sin6_addr.__u6_addr.__u6_addr32[2],sa->sin6_addr.__u6_addr.__u6_addr32[3],sa->sin6_scope_id];
	   }
    while (_ai = _ai->ai_next);
    [buf appendString:@"nil\n}"];
    return buf;
}
@end