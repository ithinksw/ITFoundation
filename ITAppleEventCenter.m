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
    if( _sharedAECenter ) {
        return _sharedAECenter;
    } else {	
        return _sharedAECenter = [[ITAppleEventCenter alloc] init];
    }
}

- (NSString*)sendAEWithRequestedKey:(NSString*)key eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    //Add error checking...
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID	 eID    = *((unsigned long*)[eventID UTF8String]);
    
    const char *sendString = [[NSString stringWithFormat:@"'----':obj { form:'prop', want:type('prop'), seld:type('%s'), from:'null'() }", [key UTF8String]] UTF8String];
    NSString  *_finalString = nil;
    
    AppleEvent sendEvent, replyEvent;
    AEIdleUPP upp = NewAEIdleUPP(&MyAEIdleCallback);
    
    DescType resultType;
    Size resultSize, charResultSize;
    
    AEBuildError buildError;
    OSStatus err;
    OSErr err2, err3;
    /*
    if ((GetProcessPID(&psn, &pid) == noErr) && (pid == 0)) {
        NSLog(@"Error getting PID of application! Exiting.");
        return nil;
    }
    */
    //NSLog(@"_sendString: %s", sendString);
    
    err = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);
    
    //[self printCarbonDesc:&sendEvent];
    
    if (err) {
        NSLog(@"%d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[sendString substringToIndex:buildError.fErrorPos]);
    }
    
    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, kNoTimeOut, upp, NULL);
    
    //[self printCarbonDesc:&replyEvent];
    
    if (err) {
        NSLog(@"Send Error: %i",err);
    } else {
        unichar *result = 0;
        
        err2 = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);
        result = malloc(resultSize);
        
        if (err2) {
            NSLog(@"Error After AESizeOfParam: %i", err2);
        } else {
            err3 = AEGetParamPtr(&replyEvent, keyDirectObject, resultType, NULL, result, resultSize, &charResultSize);
            
            if (err3) {
                NSLog(@"Error After AEGetParamPtr: %i", err3);
            } else {
                _finalString = [[NSString stringWithCharacters:result length:charResultSize/sizeof(unichar)] copy];
            }
        }
        free(result);
    }
    
    AEDisposeDesc(&sendEvent);
    AEDisposeDesc(&replyEvent);
    
    return _finalString;
}

- (long)sendAEWithRequestedKeyForNumber:(NSString*)key eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    //Add error checking...
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);
    
    const char *sendString = [[NSString stringWithFormat:@"'----':obj { form:'prop', want:type('prop'), seld:type('%s'), from:'null'() }", [key UTF8String]] UTF8String];
    long result = 0;
    
    AppleEvent sendEvent, replyEvent;
    AEIdleUPP upp = NewAEIdleUPP(&MyAEIdleCallback);
    
    DescType resultType;
    Size resultSize, charResultSize;
    
    AEBuildError buildError;
    OSStatus err;
    OSErr err2, err3;
    /*
    if ((GetProcessPID(&psn, &pid) == noErr) && (pid == 0)) {
        NSLog(@"Error getting PID of application! Exiting.");
        return nil;
    }
    */
    //NSLog(@"_sendString: %s", sendString);
    
    err = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);
    
    //[self printCarbonDesc:&sendEvent];
    
    if (err) {
        NSLog(@"%d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[sendString substringToIndex:buildError.fErrorPos]);
    }
    
    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, kNoTimeOut, upp, NULL);
    
    [self printCarbonDesc:&replyEvent];
    
    if (err) {
        NSLog(@"Send Error: %i",err);
    } else {
        err2 = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);
        
        if (err2) {
            NSLog(@"Error After AESizeOfParam: %i", err2);
        } else {
            err3 = AEGetParamPtr(&replyEvent, keyDirectObject, resultType, NULL, &result, resultSize, &charResultSize);
            
            if (err3) {
                NSLog(@"Error After AEGetParamPtr: %i", err3);
            } else {
                NSLog(@"%i", result);
            }
        }
    }
    
    AEDisposeDesc(&sendEvent);
    AEDisposeDesc(&replyEvent);
    
    return result;
}

- (NSString*)sendTwoTierAEWithRequestedKey:(NSString*)key fromObjectByKey:(NSString*)object eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    //Add error checking...
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);
    
    const char *sendString = [[NSString stringWithFormat:@"'----':obj { form:'prop', want:type('prop'), seld:type('%s'), from:obj { form:'prop', want:type('prop'), seld:type('%s'), from:'null'() } }", [key UTF8String], [object UTF8String]] UTF8String];
    NSString  *_finalString = nil;
    
    AppleEvent sendEvent, replyEvent;
    AEIdleUPP upp = NewAEIdleUPP(&MyAEIdleCallback);
    
    DescType resultType;
    Size resultSize, charResultSize;
    
    AEBuildError buildError;
    OSStatus err;
    OSErr err2, err3;
    /*
    if ((GetProcessPID(&psn, &pid) == noErr) && (pid == 0)) {
        NSLog(@"Error getting PID of application! Exiting.");
        return nil;
    }*/
    
    //NSLog(@"_sendString: %s", sendString);
    
    err = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);
    
    //[self printCarbonDesc:&sendEvent];
    
    if (err) {
        NSLog(@"%d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[sendString substringToIndex:buildError.fErrorPos]);
    }
    
    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, kNoTimeOut, upp, NULL);
    
    //[self printCarbonDesc:&replyEvent];
    
    if (err) {
        NSLog(@"Send Error: %i",err);
    } else {
        unichar *result = 0;
        
        err2 = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);
        result = malloc(resultSize);
        
        if (err2) {
            NSLog(@"Error After AESizeOfParam: %i", err2);
        } else {
            err3 = AEGetParamPtr(&replyEvent, keyDirectObject, resultType, NULL, result, resultSize, &charResultSize);
            
            if (err3) {
                NSLog(@"Error After AEGetParamPtr: %i", err3);
            } else {
                _finalString = [[NSString stringWithCharacters:result length:charResultSize/sizeof(unichar)] copy];
            }
        }
        free(result);
    }
    
    AEDisposeDesc(&sendEvent);
    AEDisposeDesc(&replyEvent);
    
    return _finalString;
}

- (long)sendTwoTierAEWithRequestedKeyForNumber:(NSString*)key fromObjectByKey:(NSString*)object eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    //Add error checking...
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);
    
    const char *sendString = [[NSString stringWithFormat:@"'----':obj { form:'prop', want:type('prop'), seld:type('%s'), from:obj { form:'prop', want:type('prop'), seld:type('%s'), from:'null'() } }", [key UTF8String], [object UTF8String]] UTF8String];
    long result = 0;
    
    AppleEvent sendEvent, replyEvent;
    AEIdleUPP upp = NewAEIdleUPP(&MyAEIdleCallback);
    
    DescType resultType;
    Size resultSize, charResultSize;
    
    AEBuildError buildError;
    OSStatus err;
    OSErr err2, err3;
    /*
    if ((GetProcessPID(&psn, &pid) == noErr) && (pid == 0)) {
        NSLog(@"Error getting PID of application! Exiting.");
        return nil;
    }
    */
   // NSLog(@"_sendString: %s", sendString);
    
    err = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);
    
    //[self printCarbonDesc:&sendEvent];
    
    if (err) {
        NSLog(@"%d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[sendString substringToIndex:buildError.fErrorPos]);
    }
    
    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, kNoTimeOut, upp, NULL);
    
    [self printCarbonDesc:&replyEvent];
    
    if (err) {
        NSLog(@"Send Error: %i",err);
    } else {
        err2 = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);
        
        if (err2) {
            NSLog(@"Error After AESizeOfParam: %i", err2);
        } else {
            err3 = AEGetParamPtr(&replyEvent, keyDirectObject, resultType, NULL, &result, resultSize, &charResultSize);
            
            if (err3) {
                NSLog(@"Error After AEGetParamPtr: %i", err3);
            } else {
                NSLog(@"%i", result);
            }
        }
    }
    
    AEDisposeDesc(&sendEvent);
    AEDisposeDesc(&replyEvent);
    
    return result;
}

- (NSString *)sendAEWithRequestedArray:(NSArray *)array eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    NSString *buildString = [NSString stringWithFormat:@"{ form:'prop', want:type('prop'), seld:type('%s'), from:'null'() }", [[array objectAtIndex:0] UTF8String]];
    const char *sendString;
    int i;
    NSString  *_finalString = nil;
    
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);
    
    AppleEvent sendEvent, replyEvent;
    AEIdleUPP upp = NewAEIdleUPP(&MyAEIdleCallback);
    
    DescType resultType;
    Size resultSize, charResultSize;
    
    AEBuildError buildError;
    OSStatus err;
    OSErr err2, err3;
    
    for (i = 1; i < [array count]; i++) {
        NSString *from = [NSString stringWithFormat:@"{ form:'prop', want:type('prop'), seld:type('%s'), from:obj %@ }",
                    [[array objectAtIndex:i] UTF8String], buildString];
        buildString = from;
    }
    buildString = [@"'----':obj " stringByAppendingString:buildString];
    sendString = [buildString UTF8String];
    /*
    if ((GetProcessPID(&psn, &pid) == noErr) && (pid == 0)) {
        NSLog(@"Error getting PID of application! Exiting.");
        return nil;
    }
    */
    //NSLog(@"_sendString: %s", sendString);
    
    err = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);
    
    //[self printCarbonDesc:&sendEvent];
    
    if (err) {
        NSLog(@"%d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[sendString substringToIndex:buildError.fErrorPos]);
    }
    
    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, kNoTimeOut, upp, NULL);
    
    //[self printCarbonDesc:&replyEvent];
    
    if (err) {
        NSLog(@"Send Error: %i",err);
    } else {
        unichar *result = 0;
        
        err2 = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);
        result=malloc(resultSize);
        
        if (err2) {
            NSLog(@"Error After AESizeOfParam: %i", err2);
        } else {
            err3 = AEGetParamPtr(&replyEvent, keyDirectObject, resultType, NULL, result, resultSize, &charResultSize);
            if (err3) {
                NSLog(@"Error After AEGetParamPtr: %i", err3);
            } else {
                _finalString = [[NSString stringWithCharacters:result length:charResultSize/sizeof(unichar)] copy];
            }
        }
        free(result);
    }
    return _finalString;
}

- (void)sendAEWithEventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    //Add error checking...
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);
    AEDesc dest;
    AppleEvent event, reply;

    //AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, kAnyTransactionID, &event, nil, "");
    AECreateDesc(typeProcessSerialNumber,(ProcessSerialNumber*)&psn,sizeof(ProcessSerialNumber),&dest);
    AECreateAppleEvent(eClass,eID,&dest,kAutoGenerateReturnID,kAnyTransactionID,&event);
    AESend(&event, &reply, kAENoReply, kAENormalPriority, kAEDefaultTimeout, nil, nil);
    
    AEDisposeDesc(&dest);
    AEDisposeDesc(&event);
    AEDisposeDesc(&reply);
}

- (void)printCarbonDesc:(AEDesc*)desc {
    Handle xx;
    AEPrintDescToHandle(desc,&xx);
    NSLog(@"Handle: %s", *xx);
    DisposeHandle(xx);
}


- (AEArrayDataPointer)sendAEWithRequestedKeyForArray:(NSString*)key eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    //Add error checking...
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID	 eID    = *((unsigned long*)[eventID UTF8String]);

    const char *sendString = [[NSString stringWithFormat:@"'----':obj { form:'prop', want:type('prop'), seld:type('%s'), from:'null'() }", [key UTF8String]] UTF8String];
    AEArrayDataPointer result = nil;

    AppleEvent sendEvent, replyEvent;
    AEIdleUPP upp = NewAEIdleUPP(&MyAEIdleCallback);

    DescType resultType;
    Size resultSize, charResultSize;

    AEBuildError buildError;
    OSStatus err;
    OSErr err2, err3;

    //NSLog(@"_sendString: %s", sendString);

    err = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);

    //[self printCarbonDesc:&sendEvent];

    if (err) {
        NSLog(@"%d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[sendString substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, kNoTimeOut, upp, NULL);

    //[self printCarbonDesc:&replyEvent];

    if (err) {
        NSLog(@"Send Error: %i",err);
    } else {
	   SInt32 count, resultCount;

	   AECountItems(&replyEvent,&count);
	   result=malloc(sizeof(AEDesc)*count);
	   AEGetArray(&replyEvent, kAEDescArray, result, sizeof(AEDesc)*count, NULL, NULL, &resultCount);

        free(result);
    }

    AEDisposeDesc(&sendEvent);
    AEDisposeDesc(&replyEvent);

    return result;
}

@end
