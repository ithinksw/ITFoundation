//
//  ITByteStream.h
//  ITFoundation
//
//  Created by Alexander Strange on Thu Feb 27 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
/*! @class ITByteStream
 *  @abstract A FIFO bytestream
 */

@interface ITByteStream : NSObject {
    @public
    NSMutableData *data;
    @private
    NSLock *lock;
}
-(id) initWithStream:(ITByteStream*)stream;
-(int) availableDataLength;
-(NSData*) readDataOfLength:(int)length;
-(NSData*) readAllData;
-(void) writeData:(in NSData*)data;
@end
