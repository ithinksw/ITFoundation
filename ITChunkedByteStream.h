//
//  ITChunkedByteStream.h
//  ITFoundation
//
//  Created by Alexander Strange on Tue Jul 22 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITByteStream.h"
#import "ArrayQueue.h"

@interface ITChunkedByteStream : NSObject <Delegater> {
    @public
    ArrayQueue *q;
    @private
    NSLock *lock;
    id delegate;
}
-(BOOL)empty;
-(NSData*) readData;
-(oneway void) writeData:(in NSData*)data;
-(oneway void) writeBytesNoCopy:(in char *)b len:(unsigned long)length;
-(oneway void) writeBytes:(in char *)b len:(unsigned long)length;
-initWithDelegate:(id)delegate;
-setDelegate:(id)delegate;
-delegate; 
@end
