//
//  ShowcaseController.m
//  ITFoundation
//
//  Created by Alexander Strange on Fri Feb 14 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "ShowcaseController.h"


@implementation ShowcaseController
- (void)applicationDidFinishLaunching:(NSNotification *)note
{
    
    ITInetServerSocket *sock = [[ITInetServerSocket alloc] initWithDelegate:self];
    NSLog(@"rawr?");
    [sock setPort:4776];
    [sock setServiceName:@"Test Rendezvous Service"];
    [sock setServiceType:@"ittest" useForPort:NO];
    [sock start];
}

- (void)newClientJoined:(ITInetSocket*)client
{
}
@end
