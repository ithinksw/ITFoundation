//
//  ITByteStream.h
//  ITFoundation
//
//  Created by Alexander Strange on Thu Feb 27 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "ITByteStream.h"

// TODO: Add NSCopying/NSCoding support

@implementation ITByteStream
-(id) init
{
    if (self == [super init])
	   {
	   data = [[NSMutableData alloc] init];
	   }
    return self;
}

-(id) initWithStream:(ITByteStream*)stream
{
    if (self == [super init])
	   {
	   data = [stream->data copy];
	   }
    return 0;
}

-(void) dealloc
{
    [data release];
    [super dealloc];
}

-(int) availableDataLength
{
    return [data length];
}

-(NSData*) readDataOfLength:(int)length
{
    NSData *ret, *tmp;
    NSRange range = {0, length};
    ret = [data subdataWithRange:range];
#if MAC_OS_X_VERSION_10_2 <= MAC_OS_X_VERSION_MAX_ALLOWED
    [data replaceBytesInRange:range withBytes:nil length:0]; // this should delete off the end. should test.
#else
    range = {length, [data length]};
    tmp = [data subdataWithRange:range];
    [data setData:tmp]; // maybe i should add a lock to this? it would be bad if someone was writing when it was reading...
#endif
    return ret;
}

-(void) writeData:(NSData*)_data
{
    [data appendData:_data];
}
@end
