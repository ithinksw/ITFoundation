//
//  ITInetSocket.h
//  ITFoundation
//
//  Created by Alexander Strange on Tue Feb 11 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ITInetSocketOwner
- (void)requestCompleted:(NSString*)data;
@end

enum {
    ITInetMaxConnections = 36
};

@interface ITInetSocket : NSObject {
    int sockfd;
    int port;
    NSString *destAddr;
}
// Init
-(id) initWithFD:(int)fd;
-(id) initWithFD:(int)fd delegate:(id)d;
-(id) initWithDelegate:(id)d;

+(NSArray*) socketsForRendezvousScan; //need args

// Mutators (some of these must be set before you can connect)
-(void) setPort:(int)port;
-(void) setPortViaServiceName:(NSString*)name;
-(void) setDest:(NSString*)dst;
@end
