//
//  ITByteStream.h
//  ITFoundation
//
//  Created by Alexander Strange on Thu Feb 27 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "ITByteStream.h"

// TODO: Add NSCopying/NSCoding support. Blocking reads (how would this work? NSConditionLock?)

@implementation ITByteStream
-(id) init
{
    if (self == [super init])
	   {
	   data = [[NSMutableData alloc] init];
	   lock = [[NSLock alloc] init];
	   delegate = nil;
	   }
    return self;
}

-(id) initWithDelegate:(id)d
{
    if (self == [super init])
	   {
	   data = [[NSMutableData alloc] init];
	   lock = [[NSLock alloc] init];
	   delegate = [d retain];
	   }
    return self;
}

-(id) initWithStream:(ITByteStream*)stream delegate:(id)d
{
    if (self == [super init])
	   {
	   data = [stream->data copy];
	   lock = [[NSLock alloc] init];
	   delegate = [d retain];
	   }
    return 0;
}

-(oneway void) dealloc
{
    [lock lock];
    [data release];
    [lock unlock];
    [lock release];
    [super dealloc];
}

-(void) setDelegate:(id <ITByteStreamDelegate>)d
{
    [delegate release];
    delegate = [d retain];
}

-(int) availableDataLength
{
    int len;
    [lock lock];
    len = [data length];
    [lock unlock];
    return len;
}

-(NSData*) readDataOfLength:(int)length
{
    NSData *ret, *tmp;
    NSRange range = {0, length};
    [lock lock];
    ret = [data subdataWithRange:range];
#if MAC_OS_X_VERSION_10_2 <= MAC_OS_X_VERSION_MAX_ALLOWED
    [data replaceBytesInRange:range withBytes:nil length:0];
#else
    range = {length, [data length]};
    tmp = [data subdataWithRange:range];
    [data setData:tmp];
#endif
    [lock unlock];
    return ret;
}

-(NSData*) readAllData
{
    NSData *ret;
    [lock lock];
    ret = [data autorelease];
    data = [[NSMutableData alloc] init];
    [lock unlock];
    return ret;
}

-(void) writeData:(in NSData*)_data
{
    [lock lock];
    [data appendData:_data];
    [lock unlock];
    [delegate newDataAdded:self];
}

-(void) writeBytes:(char *)b len:(long)length
{
    [lock lock];
    [data appendBytes:b length:length];
    [lock unlock];
    [delegate newDataAdded:self];
}
@end
