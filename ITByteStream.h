//
//  ITByteStream.h
//  ITFoundation
//
//  Created by Alexander Strange on Thu Feb 27 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITByteStream;
@protocol DataReciever <NSObject>
-(oneway void)newDataAdded:(id)sender;
@end
@interface ITByteStream : NSObject <Delegater> {
    @public
    NSMutableData *data;
    @private
    NSLock *lock;
    id <DataReciever> delegate;
}
-(id) initWithStream:(ITByteStream*)stream delegate:(id <DataReciever>)d;
-(int) availableDataLength;
-(NSData*) readDataOfLength:(int)length;
-(NSData*) readAllData;
-(void) writeData:(in NSData*)data;
-(void) writeBytes:(in char *)b len:(long)length;
-(void) lockStream;
-(void) unlockStream;
-(void) shortenData:(long)length;
@end
