/*
 *	ITFoundation
 *      ITOSAScript
 *          An extended NSAppleScript that allows any OSA language.
 *
 *	Original Author	: Kent Sutherland <ksutherland@ithinksw.com>
 *      Responsibility : Kent Sutherland <ksutherland@ithinksw.com>
 *      Responsibility : Joseph Spiros <joseph.spiros@ithinksw.com>
 *
 *	Copyright (c) 2002 - 2004 iThink Software.
 *	All Rights Reserved
 *
 */

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

@class ITOSAComponent;

@interface ITOSAScript : NSObject {
    NSString *_source;
    ITOSAComponent *_component;
    OSAID _scriptID;
}

- (id)initWithContentsOfFile:(NSString *)path;
- (id)initWithSource:(NSString *)source;

- (NSString *)source;

- (ITOSAComponent *)component;
- (void)setComponent:(ITOSAComponent *)newComponent;

- (BOOL)compileAndReturnError:(NSDictionary **)errorInfo;
- (BOOL)isCompiled;

- (NSAppleEventDescriptor *)executeAndReturnError:(NSDictionary **)errorInfo;

@end
