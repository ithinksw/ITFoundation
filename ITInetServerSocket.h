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
    int sockfd;
    NSMutableSet *clients;
    NSNetService *service;
    id delegate;
}

- (id)init;
- (id)initWithServiceName:(NSString*)name delegate:(id)d;
- (id)initWithPort:(NSNumber*)port rendezvousName:(NSString*)name delegate:(id)d;

- (int)sockfd;
- (NSSet*)clients;
- (id)delegate;
@end
