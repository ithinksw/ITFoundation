//
//  ITInetSocket.h
//  ITFoundation
//
//  Created by Alexander Strange on Tue Feb 11 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <netinet/in.h>

enum {
    ITInetMaxConnections = 36
};

typedef enum {
    ITInetSocketConnecting,
    ITInetSocketReady,
    ITInetSocketDisconnected
} ITInetSocketState;

@protocol ITInetSocketOwner
- (void) requestCompleted:(in NSData*)data;
- (void) errorOccured:(int)err during:(ITInetSocketState)state;
- (void) finishedConnecting;
@end

@interface ITInetSocket : NSObject {
    @public
    int sockfd;
    int port;
    id delegate;
    struct sockaddr_in6 sa;
    NSMutableData *requestBuffer;
    ITInetSocketState state;
}
// Init
-(id) initWithFD:(int)fd delegate:(id)d;
-(id) initWithDelegate:(id)d;

-(void) connectToHost:(NSString*)host onPort:(short)port;

-(ITInetSocketState) state;

@end
