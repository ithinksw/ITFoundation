#import "ITAppleEventCenter.h"

Boolean MyAEIdleCallback (
					 EventRecord * theEvent,
					 SInt32 * sleepTime,
					 RgnHandle * mouseRgn
					 );

Boolean MyAEIdleCallback (
					 EventRecord * theEvent,
					 SInt32 * sleepTime,
					 RgnHandle * mouseRgn
					 )
{
    return FALSE;
}

@implementation ITAppleEventCenter

static ITAppleEventCenter *_sharedAECenter = nil;

+ (id)sharedCenter
{
    if( _sharedAECenter != nil ) {
        return _sharedAECenter;
    } else {	
        _sharedAECenter = [[ITAppleEventCenter alloc] init];
        return _sharedAECenter;
    }
}

- (NSString*)runAEWithRequestedKey:(NSString*)key eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);
    
    const char *sendString = [[NSString stringWithFormat:@"'----':obj { form:'prop', want:type('prop'), seld:type('%s'), from:'null'() }", [key UTF8String]] UTF8String];
    NSString  *_finalString;
    
    // Variables for building and sending the event    
    AppleEvent sendEvent, replyEvent;
    //AEDesc replyDesc;
    AEIdleUPP upp = NewAEIdleUPP(&MyAEIdleCallback);
    
    // Variables for getting the result
    char *charResult;
    DescType resultType;
    Size resultSize, charResultSize;
    int pid;
    
    // Variables for error checking
    AEBuildError buildError;
    OSStatus err;
    OSErr err2, err3;
    //Ptr buffer;
    //Size length;
    
    // Start Code
    // ^ Most pointless comment EVAR!
    // ^^ Nope, that one is
    
    if (GetProcessPID(&psn, &pid) == noErr) {
        if (pid ==0) {
            NSLog(@"Process doesn't exist! Exiting.");
            return;
        }
    } else {
        NSLog(@"Error getting PID of application to send to! Exiting.");
        return;
    }
    
    NSLog(@"_sendString: %s", sendString);
    
    // The problem is, if I use eClass and eID in place of 'core' and 'getd' respectively, It won't build a valid AppleEvent :'(
    err = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);
    
    [self printCarbonDesc:&sendEvent];
    
    if (err) {
        NSLog(@"%d:%d at \"%@\"",buildError.fError,buildError.fErrorPos,[sendString substringToIndex:buildError.fErrorPos]);
    }
    
    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, kNoTimeOut, upp, NULL);
    
    [self printCarbonDesc:&replyEvent];
    
    if (err) {
        NSLog(@"Send Error: %i",err);
    } else {

        unichar* result=0;
        
        err2 = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);
        result=malloc(resultSize);
        //err2 = AEGetParamDesc(&replyEvent, keyDirectObject, typeWildCard, &replyDesc);
        
        if (err2) { NSLog(@"Error After AESizeOfParam: %i", err2); } else {
        //if (err2) { NSLog(@"Error After AEGetParamDesc: %i", err2); } else {
        
        err3 = AEGetParamPtr(&replyEvent, keyDirectObject, resultType, NULL, result, resultSize, &charResultSize);
        //length = AEGetDescDataSize(&replyDesc);
        //buffer = malloc(length);
    
        //err3 = AEGetDescData(&replyDesc, buffer, length);
        
        if (err3) { NSLog(@"Error After AEGetParamPtr: %i", err3); } else {
        
        // if (err3) { NSLog(@"Error After AEGetDescData: %i", err3); } else {
        
        _finalString = [[NSString stringWithCharacters:result length:charResultSize/sizeof(unichar)] copy];
        
        /* _finalString = [NSString stringWithCString:buffer length:length];
        
        if ( (! [_finalString isEqualToString:@""])      &&
            ([_finalString characterAtIndex:0] == '\"') &&
            ([_finalString characterAtIndex:[_finalString length] - 1] == '\"') ) {
            _finalString = [_finalString substringWithRange:NSMakeRange(1, [_finalString length] - 2)];
        }
        free(buffer);
        buffer = nil; */

        }
        }
    }
    
    //NSLog(@"Result Size: %i", charResultSize);
    //NSLog(@"Result: %c", charResult);
    
    AEDisposeDesc(&sendEvent);
    AEDisposeDesc(&replyEvent);
    
    return _finalString;
}

- (void)printCarbonDesc:(AEDesc*)desc {
    Handle xx;
    AEPrintDescToHandle(desc,&xx);
    NSLog(@"Handle: %s", *xx);
    DisposeHandle(xx);
}

@end
