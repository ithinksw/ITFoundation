//
//  ITInetServerSocket.h
//  ITFoundation
//
//  Created by Alexander Strange on Thu Feb 13 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITInetSocket;

@protocol ITInetServerSocketOwner
- (void)newClientJoined:(ITInetSocket*)client;
@end

@interface ITInetServerSocket : NSObject {
    @private
    int sockfd;
    NSMutableSet *clients;
    NSNetService *service;
    id delegate;
    short port;
    NSString *rndType,*rndName;
}

- (id)init;
- (id)initWithDelegate:(id)d;

- (BOOL)start;
- (void)stop;

- (int)sockfd;
- (NSSet*)clients;
- (id)delegate;
- (short)port;

- (void)setServiceType:(NSString*)type useForPort:(BOOL)p;
- (void)setServiceName:(NSString*)name; // generally the computer's AppleTalk name
- (void)setPort:(short)p;
@end
