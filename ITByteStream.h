//
//  ITByteStream.h
//  ITFoundation
//
//  Created by Alexander Strange on Thu Feb 27 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITByteStream;

@protocol ITByteStreamDelegate
-(oneway void)newDataAdded:(ITByteStream *)sender;
@end

@interface ITByteStream : NSObject {
    @public
    NSMutableData *data;
    @private
    NSLock *lock;
    id <ITByteStreamDelegate> delegate;
}
-(id) initWithStream:(ITByteStream*)stream delegate:(id <ITByteStreamDelegate>)d;
-(id) initWithDelegate:(id <ITByteStreamDelegate>)d;
-(void) setDelegate:(id <ITByteStreamDelegate>)d;
-(int) availableDataLength;
-(NSData*) readDataOfLength:(int)length;
-(NSData*) readAllData;
-(void) writeData:(in NSData*)data;
-(void) writeBytes:(char *)b len:(long)length;
@end
