/*
 *	ITFoundation
 *	ITAppleEvent
 *
 *	Class that provides utilities for sending AppleEvents
 *	(and OSA scripts) using Carbon function calls in Cocoa
 *
 *	Original Author	: Joseph Spiros <joseph.spiros@ithinksw.com>
 *	Responsibility	: Joseph Spiros <joseph.spiros@ithinksw.com>
 *			: Kent Sutherland <kent.sutherland@ithinksw.com>
 *
 *	Copyright (c) 2002 iThink Software.
 *	All Rights Reserved
 *
 */

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>


@interface ITAppleEvent : NSObject {
    long int osaScriptID;
    AppleEvent event, reply;
}
/*
 *	INITIALIZATION METHODS - AppleScript
 *
 *	These methods initialize an instance of ITAppleEvent
 *	with AppleScript/OpenScripting data
 */
- (id)initWithOSASource:(NSString *)source;
- (id)initWithOSACompiledData:(NSData *)data;
- (id)initWithOSAFromContentsOfURL:(NSURL *)url;
- (id)initWithOSAFromContentsOfPath:(NSString *)path;
/*
`*	INITIALIZATION METHODS - AppleEvent
 *
 *	This method initializes an instance of ITAppleEvent
 *	with an AppleEvent class (usually the creator id
 *	of the AppleEvent's target) and an AppleEvent ID
 */
- (id)initWithAppleEventClass:(AEEventClass)eventClass appleEventID:(AEEventID)eventID;
/*
 *	INSTANCE METHODS
 */
- (NSString *)OSASource;
- (void)setOSASource:(NSString *)source;
- (NSData *)OSACompiledData;
- (void)setOSACompiledData:(NSData *)data;
- (AEEventClass)appleEventClass;
- (AEEventID)appleEventID;
- (NSString *)execute;
@end
