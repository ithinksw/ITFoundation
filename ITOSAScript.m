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

/*
Script Subtypes:
    kAppleScriptSubtype - AppleScript (Default)
    'Jscr' - JavaScript (if installed)
*/

#import "ITOSAScript.h"
#import "ITOSAComponent.h"

#warning To do - Error Dictionaries

@implementation ITOSAScript

- (id)init
{
    return nil; // initWithSource: is the designated initializer for this class
}

- (id)initWithContentsOfFile:(NSString *)path
{
    return [self initWithSource:[[[NSString alloc] initWithContentsOfFile:path] autorelease]];
}

- (id)initWithSource:(NSString *)source
{
    if ( (self = [super init]) ) {
        _source = [source copy];
        _scriptID = kOSANullScript;
    }
    return self;
}

- (void)dealloc
{
    if (_scriptID != kOSANullScript) {
        OSADispose([_component componentInstance], _scriptID);
    }
    
    [_source release];
    [super dealloc];
}

- (NSString *)source
{
    return _source;
}

- (ITOSAComponent *)component
{
    return _component;
}

- (void)setComponent:(ITOSAComponent *)newComponent
{
    _component = newComponent;
}

- (BOOL)compileAndReturnError:(NSDictionary **)errorInfo
{
    if ([_component componentInstance] == nil) {
        //Set the error dictionary
        return NO;
    }
    
    AEDesc moof;
    AECreateDesc(typeChar, [_source cString], [_source cStringLength], &moof);
    if (OSACompile([_component componentInstance], &moof, kOSAModeNull, &_scriptID) != 0) {
        NSLog(@"Compile error!");
        return NO;
    }
    return YES;
}

- (BOOL)isCompiled
{
    return (_scriptID != kOSANullScript);
}

- (NSAppleEventDescriptor *)executeAndReturnError:(NSDictionary **)errorInfo
{
    if ([_component componentInstance] == nil) {
        //Set the error dictionary
        return nil;
    }
    
    NSAppleEventDescriptor *cocoaDesc;
    
    AEDesc scriptDesc, resultDesc;
    OSAID resultID = kOSANullScript;
    
    //If not compiled, compile it
    if (![self isCompiled]) {
        if (![self compileAndReturnError:nil]) {
            //Set the error info dictionary
            return nil;
        }
    }
    
    OSAExecute([_component componentInstance], _scriptID, kOSANullScript, kOSANullMode, &resultID);
    
    OSACoerceToDesc([_component componentInstance], resultID, typeWildCard, kOSAModeNull, &resultDesc); // Using this instead of OSADisplay, as we don't care about human readability, but rather, the integrity of the data.
    
    cocoaDesc = [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&resultDesc];
    
    AEDisposeDesc(&scriptDesc);
    
    OSADispose([_component componentInstance], resultID);
    
    return [cocoaDesc autorelease];
}

@end
