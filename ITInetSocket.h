//
//  ITInetSocket.h
//  ITFoundation
//
//  Created by Alexander Strange on Tue Feb 11 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <netinet/in.h>
#import <netdb.h>

enum {
    ITInetMaxConnections = 36
};

typedef enum {
    ITInetSocketConnecting,
    ITInetSocketListening,
    ITInetSocketReading,
    ITInetSocketWriting,
    ITInetSocketDisconnected
} ITInetSocketState;

typedef enum {
    ITInetHostNotFound,
    ITInetConnectionDropped,
    ITInetCouldNotConnect,
} ITInetSocketError;

@protocol ITInetSocketOwner
- (void) dataRecieved:(in NSData*)data;
- (void) errorOccured:(ITInetSocketError)err during:(ITInetSocketState)state;
- (void) finishedConnecting;
@end

@interface ITInetSocket : NSObject {
    @public
    int sockfd;
    int port;
    id delegate;
    struct addrinfo *ai;
    NSData *writeBuffer;
    ITInetSocketState state;
}
-(id) initWithFD:(int)fd delegate:(id)d;
-(id) initWithDelegate:(id)d;

-(void) connectToHost:(NSString*)host onPort:(short)port;
-(ITInetSocketState) state;
@end
