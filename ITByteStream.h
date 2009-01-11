/*
 *	ITFoundation
 *	ITByteStream.h
 *
 *	Copyright (c) 2005 iThink Software
 *
 */

#import <Foundation/Foundation.h>

@protocol ITDataReceiver;

@protocol ITDataProvider <NSObject>
- (id <ITDataReceiver>)setDelegate:(id <ITDataReceiver>)delegate;
- (id <ITDataReceiver>)delegate;
@end

@protocol ITDataReceiver <NSObject>
-(oneway void)newDataAdded:(id <ITDataProvider>)sender;
@end

@interface ITByteStream : NSObject <ITDataProvider> {
	@public
	NSMutableData *data;
	@private
	NSLock *lock;
	id <ITDataReceiver> delegate;
}

- (id)initWithDelegate:(id <ITDataReceiver>)delegate;
- (id)initWithStream:(ITByteStream *)stream delegate:(id <ITDataReceiver>)d;
- (int)availableDataLength;
- (NSData*)readDataOfLength:(int)length;
- (NSData*)readAllData;
- (void)writeData:(in NSData *)data;
- (void)writeBytes:(in char *)b len:(long)length;
- (void)lockStream;
- (void)unlockStream;
- (void)shortenData:(long)length;
- (id <ITDataReceiver>)setDelegate:(id <ITDataReceiver>)delegate;
- (id <ITDataReceiver>)delegate;

@end