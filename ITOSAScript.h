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

@interface ITOSAScript : NSObject {
    NSString *_source;
    unsigned long _scriptSubtype;
}

- (id)initWithContentsOfFile:(NSString *)path;
- (id)initWithSource:(NSString *)source;

- (NSString *)source;
- (void)setSource:(NSString *)newSource;
- (unsigned long)scriptSubtype;
- (void)setScriptSubtype:(unsigned long)newSubtype;

- (NSString *)execute;

@end
