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
#import "ITByteStream.h"

/*!
 * @header ITInetSocket
 * @abstract Definitions for the ITInetSocket class
 */

/*!
 * @constant ITInetMaxConnections
 * @abstract The maximum number of running ITInetSockets you can have.
 * @discussion The socket will error during a connection request if you are over the maximum.
 */

enum {
    ITInetMaxConnections = 128
};

/*!
 * @enum ITInetSocketState
 * @abstract Possible states of a socket
 * @constant ITInetSocketConnecting The socket is negotiating a connection.
 * @constant ITInetSocketListening The socket is a server socket.
 * @constant ITInetSocketReading The socket is reading data from the other side.
 * @constant ITInetSocketWriting The socket is sending data to the other side.
 * @constant ITInetSocketDisconnected The socket does not have a connection.
 */
typedef enum {
    ITInetSocketConnecting,
    ITInetSocketListening,
    ITInetSocketReading,
    ITInetSocketWriting,
    ITInetSocketDisconnected
} ITInetSocketState;

/*!
 * @enum ITInetSocketError
 * @abstract Possible error conditions of a socket
 * @constant ITInetHostNotFound The host specified does not actually exist.
 * @constant ITInetConnectionDropped The remote side dropped the connection.
 * @constant ITInetCouldNotConnect The socket was unable to connect for some reason
 */
typedef enum {
    ITInetHostNotFound,
    ITInetConnectionDropped,
    ITInetCouldNotConnect
} ITInetSocketError;

@class ITInetSocket;

/*!
 * @protocol ITInetSocketDelegate
 * @abstract Delegate methods for ITInetSocket
 * @discussion ITInetSockets use these methods to communicate with their delegates
 */
@protocol ITInetSocketDelegate
/*!
 * @method dataRecieved:
 * @abstract Alerts the delegate of data.
 * @discussion The delegate should check [sender readPipe] to get the data.
 * @param sender The socket that the messages came from.
 */
- (void) dataRecieved:(ITInetSocket *)sender;
/*!
 * @method errorOccured:during:onSocket:
 * @abstract Alerts the delegate of an error condition.
 * @discussion The delegate can try retryCondition.
 * @param err The error class.
 * @param state What the socket was doing when the error occured.
 * @param sender The socket the error occured on.
 */
- (void) errorOccured:(ITInetSocketError)err during:(ITInetSocketState)state onSocket:(ITInetSocket*)sender;
/*!
 * @method finishedConnecting:
 * @abstract Alerts the delegate of a successful connection attempt.
 * @discussion The delegate should send whatever initial data is required for the protocol (nickname for IRC, etc.)
 * @param sender The socket that established the connection.
 */
- (void) finishedConnecting:(ITInetSocket *)sender;
@end

/*!
 * @class ITInetSocket
 * @abstract An Internet socket class.
 * @discussion ITInetSocket is an Internet socket class supporting IPv6 and Rendezvous.
 */
@interface ITInetSocket : NSObject {
    @public
    int sockfd;
    int port;
    id delegate;
    struct addrinfo *ai, *ai_cur;
    ITByteStream *readPipe, *writePipe;
    ITInetSocketState state;
    NSArray *sarr;
}
+(void)startAutoconnectingToService:(NSString*)type delegate:(id <ITInetSocketDelegate>)d;
-(id) initWithFD:(int)fd delegate:(id <ITInetSocketDelegate>)d;
-(id) initWithDelegate:(id <ITInetSocketDelegate>)d;

-(id <ITInetSocketDelegate>)delegate;
-(void) connectToHost:(NSString*)host onPort:(short)port;
-(void) connectToHost:(NSString*)host onNamedPort:(NSString*)port;
-(void) connectWithSockaddrArray:(NSArray*)arr;
-(ITInetSocketState) state;
-(void) retryConnection;
-(void) disconnect;
@end
