/*
 *  ITAppleEventTools.c
 *  ITFoundation
 *
 *  Created by Alexander Strange on Wed Feb 11 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */

#import "ITDebug.h"
#import "ITAppleEventTools.h"

NSAppleEventDescriptor *ITSendAEWithString(NSString *sendString, FourCharCode evClass, FourCharCode evID, ProcessSerialNumber *psn)
{
}

@implementation NSAppleEventDescriptor (ITAELogging)
-(void) logDesc
{
    Handle xx;
    AEPrintDescToHandle([self aeDesc],&xx);
    ITDebugLog(@"AE Descriptor: %s", *xx);
    DisposeHandle(xx);
}
@end