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

@implementation ITOSAScript

- (id)init
{
    if ( (self = [super init]) ) {
        _source = nil;
    }
    return self;
}

- (id)initWithContentsOfFile:(NSString *)path
{
    if ( (self = [super init]) ) {
        _source = [[NSString alloc] initWithContentsOfFile:path];
    }
    return self;
}

- (id)initWithSource:(NSString *)source
{
    if ( (self = [super init]) ) {
        [self setSource:source];
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

- (ITOSAComponent *)component
{
    return _component;
}

- (void)setComponent:(ITOSAComponent *)newComponent
{
    _component = newComponent;
}

- (BOOL)compile
{
    return NO;
}

- (BOOL)isCompiled
{
    return NO;
}

- (NSString *)execute
{
    AEDesc scriptDesc, resultDesc;
    Size length;
    NSString *result;
    Ptr buffer;
    
    AECreateDesc(typeChar, [_source cString], [_source cStringLength], &scriptDesc);
    
    OSADoScript([_component componentInstance], &scriptDesc, kOSANullScript, typeChar, kOSAModeCanInteract, &resultDesc);
    
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
