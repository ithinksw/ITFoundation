//
//  ITChunkedByteStream.m
//  ITFoundation
//
//  Created by Alexander Strange on Tue Jul 22 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "ITChunkedByteStream.h"


@implementation ITChunkedByteStream
-initWithDelegate:(id)d
{
    if (self = [super init]) {
        q = [[ArrayQueue alloc] init];
        lock = [[NSLock alloc] init];
        delegate = [d retain];
    }
    return self;
}

-(BOOL)empty
{
    BOOL a;
    [lock lock];
    a = [q isEmpty];
    [lock unlock];
    return a;
}

-(NSData*) readData
{
    NSData *d;
    [lock lock];
    d = (NSData*)[q dequeue];
    [lock unlock];
    return d;
}

-(oneway void) writeData:(in NSData*)d
{
    [lock lock];
    [q enqueue:d];
    [lock unlock];
}

-(oneway void) writeBytesNoCopy:(in char *)b len:(unsigned long)length
{
    [lock lock];
    [q enqueue:[NSData dataWithBytesNoCopy:b length:length]];
    [lock unlock];
}

-(oneway void) writeBytes:(in char *)b len:(unsigned long)length
{
    [lock lock];
    [q enqueue:[NSData dataWithBytes:b length:length]];
    [lock unlock];
}
-delegate {return delegate;}
-setDelegate:(id)d {id old = delegate; [delegate release]; delegate = [d retain]; return old;}
@end
