/*
 *  ITAppleEventTools.h
 *  ITFoundation
 *
 *  Created by Alexander Strange on Wed Feb 11 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

extern NSAppleEventDescriptor *ITSendAEWithString(NSString *sendString, FourCharCode evClass, FourCharCode evID, ProcessSerialNumber *psn);

@interface NSAppleEventDescriptor (ITAELogging)
-(void) logDesc;
@end