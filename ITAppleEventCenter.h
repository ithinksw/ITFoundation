/*
 *	ITFoundation
 *	ITAppleEventCenter
 *
 *	A class for sending and recieving AppleEvent data.
 *	Who wants to mess with that Carbon shit anyway?
 *
 *	Original Author	: Joseph Spiros <joseph.spiros@ithinksw.com>
 *	Responsibility	: Joseph Spiros <joseph.spiros@ithinksw.com>
 *			: Kent Sutherland <kent.sutherland@ithinksw.com>
 *			: Matt Judy <matt.judy@ithinksw.com>
 *
 *	Copyright (c) 2002 - 2003 iThink Software.
 *	All Rights Reserved
 *
 */

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>


@interface ITAppleEventCenter : NSObject {

}
+ (id)sharedCenter;
- (NSString*)sendAEWithRequestedKey:(NSString*)key eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn;
- (void)sendAEWithEventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn;
- (void)printCarbonDesc:(AEDesc*)desc;
@end
