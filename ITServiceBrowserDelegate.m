//
//  ITServiceBrowserDelegate.m
//  ITFoundation
//
//  Created by Alexander Strange on Sat Mar 15 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "ITServiceBrowserDelegate.h"
#import "ITInetSocket.h"
#import <Foundation/NSNetServices.h>

@implementation ITServiceBrowserDelegate
- (id) initWithDelegate:(id)_delegate
{
    if (self = [super init])
	   {
	   delegate = [_delegate retain];
	   }
    return self;
}

- (void) dealloc
{
    [delegate release];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    ITInetSocket *sock;
    NSArray *arr;
    id d = delegate;
    if (!moreComing)
	   {
	   NSLog(@"Nothing more coming");
	   [[aNetService retain] autorelease];
	   [aNetServiceBrowser stop];
	   [aNetServiceBrowser release];
	   [self release];
	   }
    sock = [[ITInetSocket alloc] initWithDelegate:d];
    NSLog(@"Detected a service! name %@ type %@",[aNetService name],[aNetService type]);
    arr = [aNetService addresses];
    if ([arr count])
	   [sock connectWithSockaddrArray:arr];
    else
	   NSLog(@"There are no sockaddrs for this service!");
}

@end
