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

@implementation ITOSAScript

- (id)init
{
    if ( (self = [super init]) ) {
        _source = nil;
        _scriptSubtype = kAppleScriptSubtype; //Default to AppleScript
    }
    return self;
}

- (id)initWithContentsOfFile:(NSString *)path
{
    if ( (self = [super init]) ) {
        _source = [[NSString alloc] initWithContentsOfFile:path];
        _scriptSubtype = kAppleScriptSubtype; //Default to AppleScript
    }
    return self;
}

- (id)initWithSource:(NSString *)source
{
    if ( (self = [super init]) ) {
        [self setSource:source];
        _scriptSubtype = kAppleScriptSubtype; //Default to AppleScript
    }
    return self;
}

- (void)dealloc
{
    [_source release];
    [super dealloc];
}

- (NSString *)source
{
    return _source;
}

- (void)setSource:(NSString *)newSource
{
    [_source release];
    _source = [newSource copy];
}

- (unsigned long)scriptSubtype
{
    return _scriptSubtype;
}

- (void)setScriptSubtype:(unsigned long)newSubtype
{
    _scriptSubtype = newSubtype;
}

- (NSString *)execute
{
    AEDesc scriptDesc, resultDesc;
    Size length;
    NSString *result;
    Ptr buffer;
    
    AECreateDesc(typeChar, [_source cString], [_source cStringLength], &scriptDesc);
    
    OSADoScript(OpenDefaultComponent(kOSAComponentType, _scriptSubtype), &scriptDesc, kOSANullScript, typeChar, kOSAModeCanInteract, &resultDesc);
    
    length = AEGetDescDataSize(&resultDesc);
    buffer = malloc(length);
    
    AEGetDescData(&resultDesc, buffer, length);
    AEDisposeDesc(&scriptDesc);
    AEDisposeDesc(&resultDesc);
    result = [NSString stringWithCString:buffer length:length];
    if (![result isEqualToString:@""] &&
        ([result characterAtIndex:0] == '\"') &&
        ([result characterAtIndex:[result length] - 1] == '\"'))
    {
        result = [result substringWithRange:NSMakeRange(1, [result length] - 2)];
    }
    free(buffer);
    buffer = NULL;
    return result;
}

@end
