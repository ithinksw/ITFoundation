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

- (NSString*)sendAEWithRequestedKey:(NSString*)key eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    if ( (!key) || (!eventClass) || (!eventID) || (psn.highLongOfPSN == kNoProcess) ) {
        return @"";
    } else {
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);
    
    const char *sendString = [[NSString stringWithFormat:@"'----':obj { form:'prop', want:type('prop'), seld:type('%s'), from:'null'() }", [key UTF8String]] UTF8String];
    NSString  *_finalString;
    
    AppleEvent sendEvent, replyEvent;
    AEIdleUPP upp = NewAEIdleUPP(&MyAEIdleCallback);
    
    char *charResult;
    DescType resultType;
    Size resultSize, charResultSize;
    int pid;
    
    AEBuildError buildError;
    OSStatus err;
    OSErr err2, err3;
    
    if (GetProcessPID(&psn, &pid) == noErr) {
        if (pid ==0) {
            NSLog(@"Process doesn't exist! Exiting.");
            return nil;
        }
    } else {
        NSLog(@"Error getting PID of application to send to! Exiting.");
        return nil;
    }
    
    NSLog(@"_sendString: %s", sendString);
    
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
        
        if (err2) { NSLog(@"Error After AESizeOfParam: %i", err2); } else {
        
        err3 = AEGetParamPtr(&replyEvent, keyDirectObject, resultType, NULL, result, resultSize, &charResultSize);
        
        if (err3) { NSLog(@"Error After AEGetParamPtr: %i", err3); } else {
        
        _finalString = [[NSString stringWithCharacters:result length:charResultSize/sizeof(unichar)] copy];
        
        }
        }
    }
    
    AEDisposeDesc(&sendEvent);
    AEDisposeDesc(&replyEvent);
    
    return _finalString;
    }
}

- (NSString*)sendTwoTierAEWithRequestedKey:(NSString*)key fromObjectByKey:(NSString*)object eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    if ( (!key) || (!object) || (!eventClass) || (!eventID) || (psn.highLongOfPSN == kNoProcess) ) {
        return @"";
    } else {
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);
    
    const char *sendString = [[NSString stringWithFormat:@"'----':obj { form:'prop', want:type('prop'), seld:type('%s'), from:obj { form:'prop', want:type('prop'), seld:type('%s'), from:'null'() } }", [key UTF8String], [object UTF8String]] UTF8String];
    NSString  *_finalString;
    
    AppleEvent sendEvent, replyEvent;
    AEIdleUPP upp = NewAEIdleUPP(&MyAEIdleCallback);
    
    char *charResult;
    DescType resultType;
    Size resultSize, charResultSize;
    int pid;
    
    AEBuildError buildError;
    OSStatus err;
    OSErr err2, err3;
    
    if (GetProcessPID(&psn, &pid) == noErr) {
        if (pid ==0) {
            NSLog(@"Process doesn't exist! Exiting.");
            return nil;
        }
    } else {
        NSLog(@"Error getting PID of application to send to! Exiting.");
        return nil;
    }
    
    NSLog(@"_sendString: %s", sendString);
    
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
        
        if (err2) { NSLog(@"Error After AESizeOfParam: %i", err2); } else {
        
        err3 = AEGetParamPtr(&replyEvent, keyDirectObject, resultType, NULL, result, resultSize, &charResultSize);
        
        if (err3) { NSLog(@"Error After AEGetParamPtr: %i", err3); } else {
        
        _finalString = [[NSString stringWithCharacters:result length:charResultSize/sizeof(unichar)] copy];
        
        }
        }
    }
    
    AEDisposeDesc(&sendEvent);
    AEDisposeDesc(&replyEvent);
    
    return _finalString;
    }
}


- (void)sendAEWithEventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    if ( (!eventClass) || (!eventID) || (psn.highLongOfPSN == kNoProcess) ) {
        return;
    } else {
        AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
        AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);
        AppleEvent event, reply;
    
        AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, kAnyTransactionID, &event, nil, "");
    
        AESend(&event, &reply, kAENoReply, kAENormalPriority, kAEDefaultTimeout, nil, nil);
    
        AEDisposeDesc(&event);
        AEDisposeDesc(&reply);
    }
}

- (void)printCarbonDesc:(AEDesc*)desc {
    Handle xx;
    AEPrintDescToHandle(desc,&xx);
    NSLog(@"Handle: %s", *xx);
    DisposeHandle(xx);
}

@end
