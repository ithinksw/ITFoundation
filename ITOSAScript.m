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
        _scriptID = kOSANullScript;
    }
    return self;
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

- (NSString *)executeAndReturnError:(NSDictionary **)errorInfo
{
    if ([_component componentInstance] == nil) {
        //Set the error dictionary
        return nil;
    }
    
    AEDesc scriptDesc, resultDesc;
    Size length;
    NSString *result;
    Ptr buffer;
    OSAID resultID = kOSANullScript;
    
    //If not compiled, compile it
    if (![self isCompiled]) {
        if (![self compileAndReturnError:nil]) {
            //Set the error info dictionary
            return nil;
        }
    }
    
    OSAExecute([_component componentInstance], _scriptID, kOSANullScript, kOSANullMode, &resultID);
    
    OSADisplay([_component componentInstance], resultID, typeChar, kOSAModeDisplayForHumans, &resultDesc);
    
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
    
    OSADispose([_component componentInstance], resultID);
    
    return result;
}

@end
