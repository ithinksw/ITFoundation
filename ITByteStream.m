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

-setDelegate:(id <DataReciever>)d
{
    id old = delegate;
    [delegate release];
    delegate = [d retain];
    return old;
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
    NSData *ret;
    NSRange range = {0, length};
    [lock lock];
    ret = [data subdataWithRange:range];
    [data replaceBytesInRange:range withBytes:nil length:0];
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

-(void) writeBytes:(in char *)b len:(long)length
{
    [lock lock];
    [data appendBytes:b length:length];
    [lock unlock];
    [delegate newDataAdded:self];
}

-(void) lockStream
{
    [lock lock];
}

-(void) unlockStream
{
    [lock unlock];
}

-(void) shortenData:(long)length
{
    NSRange range = {0, length};
    [data replaceBytesInRange:range withBytes:nil length:0];
}
@end
