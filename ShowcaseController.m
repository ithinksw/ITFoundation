//
//  ShowcaseController.m
//  ITFoundation
//
//  Created by Alexander Strange on Fri Feb 14 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "ShowcaseController.h"
#import "ITInetSocket.h"
#import <Foundation/NSString.h>
#import <SystemConfiguration/SystemConfiguration.h>


@implementation ShowcaseController
- (void)awakeFromNib
{
    server = [[ITInetServerSocket alloc] initWithDelegate:self];
    [server setPort:1338];
    [server setServiceType:@"ittest" useForPort:NO];
    [server setServiceName:[(NSString*)SCDynamicStoreCopyComputerName(NULL,NULL) autorelease]];
    [server start];
    [ITInetSocket startAutoconnectingToService:@"ittest" delegate:self];
}

- (void) finishedConnecting:(ITInetSocket *)sender {
    [sender disconnect];
}

- (void) errorOccured:(ITInetSocketError)err during:(ITInetSocketState)state onSocket:(in ITInetSocket*)sender
{
}

- (void) dataReceived:(ITInetSocket *)sender
{
}

- (void) newDataAdded:(ITByteStream*)sender
{

}

- (void)newClientJoined:(ITInetSocket*)client
{
    
}
@end
