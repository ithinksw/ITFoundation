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
@protocol ITInetSocketDelegate <DataReciever>
/*!
 * @method errorOccured:during:onSocket:
 * @abstract Alerts the delegate of an error condition.
 * @discussion The delegate can try retryCondition.
 * @param err The error class.
 * @param state What the socket was doing when the error occured.
 * @param sender The socket the error occured on.
 */
- (oneway void) errorOccured:(ITInetSocketError)err during:(ITInetSocketState)state onSocket:(ITInetSocket*)sender;
/*!
 * @method finishedConnecting:
 * @abstract Alerts the delegate of a successful connection attempt.
 * @discussion The delegate should send whatever initial data is required for the protocol (nickname for IRC, etc.)
 * @param sender The socket that established the connection.
 */
- (oneway void) finishedConnecting:(ITInetSocket *)sender;
@end

/*!
 * @class ITInetSocket
 * @abstract An Internet socket class.
 * @discussion ITInetSocket is an Internet socket class supporting IPv6 and Rendezvous.
 */
@interface ITInetSocket : NSObject <DataReciever> {
    int sockfd;
    int port;
    int nc;
    unsigned short bufs;
    volatile int dieflag;
    volatile int actionflag;
    id <ITInetSocketDelegate> delegate;
    struct addrinfo *ai, *ai_cur;
    ITByteStream *readPipe, *writePipe;
    ITInetSocketState state;
    NSArray *sarr;
}
/*!
 * @method startAutoconnectingToService:delegate:
 * @abstract Automatically creates sockets whenever a certain type of Rendezvous service appears.
 * @discussion The auto-created sockets will send finishedConnecting: to the delegate.
 * @param type The type of Rendezvous service to listen on.
 * @param d The delegate that the sockets will belong to.
 */
+(void)startAutoconnectingToService:(NSString*)type delegate:(id <ITInetSocketDelegate>)d;
/*!
 * @method initWithFD:delegate:
 * @abstract Wraps a socket around an existing socket descriptor.
 * @discussion The socket will start listening on the descriptor as normal.
 * @param fd The descriptor.
 * @param d The delegate for the socket.
 */
-(id) initWithFD:(int)fd delegate:(id <ITInetSocketDelegate>)d;
/*!
 * @method initWithDelegate:
 * @abstract Creates a new socket.
 * @discussion The socket will not be connected to anything.
 * @param d The delegate of the socket.
 */
-(id) initWithDelegate:(id <ITInetSocketDelegate>)d;

-(id <ITInetSocketDelegate>)delegate;
-(unsigned short)bufferSize;
-(void)setBufferSize:(unsigned short)bufs;
-(void) connectToHost:(NSString*)host onPort:(short)port;
-(void) connectToHost:(NSString*)host onNamedPort:(NSString*)port;
-(void) connectWithSockaddrArray:(NSArray*)arr;
-(ITInetSocketState) state;
-(void) retryConnection;
-(void) disconnect;
-(ITByteStream *)readPipe;
-(ITByteStream *)writePipe;
@end
