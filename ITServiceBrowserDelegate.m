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
	   delegate = _delegate;
	   }
    return self;
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    ITInetSocket *sock;
    if (!moreComing)
	   {
	   [aNetServiceBrowser stop];
	   [aNetServiceBrowser release];
	   [self release];
	   }
    sock = [[ITInetSocket alloc] initWithDelegate:delegate];
    NSLog(@"Detected a service! name %@ type %@",[aNetService name],[aNetService type]);
    [sock connectWithSockaddrArray:[aNetService addresses]];
}

@end
