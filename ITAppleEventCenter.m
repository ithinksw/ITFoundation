#import "ITAppleEventCenter.h"
#import "ITDebug.h"

static Boolean MyAEIdleCallback (
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

- (id)init
{
    if ( ( self = [super init] ) ) {
        idleUPP = NewAEIdleUPP(MyAEIdleCallback);
    }
    return self;
}

- (void)dealloc
{
    DisposeAEIdleUPP(idleUPP);
}

- (NSString*)sendAEWithRequestedKey:(NSString*)key eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    //Add error checking...
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID	 eID    = *((unsigned long*)[eventID UTF8String]);
    int pid;
    NSString *nssendString = [NSString stringWithFormat:@"'----':obj { form:'prop', want:type('prop'), seld:type('%s'), from:'null'() }", [key UTF8String]];
    const char *sendString = [nssendString UTF8String];
    NSString  *_finalString = nil;

    AppleEvent sendEvent, replyEvent;

    DescType resultType;
    Size resultSize, charResultSize;

    AEBuildError buildError;
    OSStatus err;
    OSErr berr, err2, err3;
    
	if ((GetProcessPID(&psn, &pid) == noErr) && (pid == 0)) {
	    ITDebugLog(@"Error getting PID of application.");
	    return nil;
	}

    berr = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);
    [self printCarbonDesc:&sendEvent];

    if (berr) {
        ITDebugLog(@"Error: %d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[nssendString substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, /*kAEDefaultTimeout*/30, idleUPP, NULL);

    [self printCarbonDesc:&replyEvent];

    if (err) {
        ITDebugLog(@"Send Error: %i",err);
    } else {
        unichar *result = 0;

        err2 = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);
        if (resultSize != 0) {
            result = malloc(resultSize);
        } else {
            return nil;
        }

        if (err2) {
            ITDebugLog(@"Error After AESizeOfParam: %i", err2);
        } else {
            err3 = AEGetParamPtr(&replyEvent, keyDirectObject, resultType, NULL, result, resultSize, &charResultSize);

            if (err3) {
                ITDebugLog(@"Error After AEGetParamPtr: %i", err3);
            } else {
                _finalString = [NSString stringWithCharacters:result length:charResultSize/sizeof(unichar)];
            }
        }
        free(result);
    }

    if (!berr) AEDisposeDesc(&sendEvent);
    if (!err) AEDisposeDesc(&replyEvent);

    return _finalString;
}

- (NSString*)sendAEWithSendString:(NSString*)nssendString eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    //Add error checking...
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID	 eID    = *((unsigned long*)[eventID UTF8String]);
    int pid;

    const char *sendString = [nssendString UTF8String];
    NSString  *_finalString = nil;

    AppleEvent sendEvent, replyEvent;

    DescType resultType;
    Size resultSize, charResultSize;

    AEBuildError buildError;
    OSStatus berr,err;
    OSErr err2, err3;
    
	if ((GetProcessPID(&psn, &pid) == noErr) && (pid == 0)) {
	    ITDebugLog(@"Error getting PID of application.");
	    return nil;
	}

    berr = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);
    if (!berr) [self printCarbonDesc:&sendEvent];

    if (berr) {
        ITDebugLog(@"Error: %d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[nssendString substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, /*kAEDefaultTimeout*/30, idleUPP, NULL);
    if (!err) [self printCarbonDesc:&replyEvent];

    if (err) {
        ITDebugLog(@"Send Error: %i",err);
    } else {
        unichar *result = 0;

        err2 = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);
        if (resultSize != 0) {
            result = malloc(resultSize);
        } else {
            return nil;
        }

        if (err2) {
            ITDebugLog(@"Error After AESizeOfParam: %i", err2);
        } else {
            err3 = AEGetParamPtr(&replyEvent, keyDirectObject, resultType, NULL, result, resultSize, &charResultSize);

            if (err3) {
                ITDebugLog(@"Error After AEGetParamPtr: %i", err3);
            } else {
                _finalString = [NSString stringWithCharacters:result length:charResultSize/sizeof(unichar)];
            }
        }
        free(result);
    }

    if (!berr) AEDisposeDesc(&sendEvent);
    if (!err) AEDisposeDesc(&replyEvent);

    return _finalString;
}

- (long)sendAEWithRequestedKeyForNumber:(NSString*)key eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    //Add error checking...
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);
    int pid;

    NSString *nssendString = [NSString stringWithFormat:@"'----':obj { form:'prop', want:type('prop'), seld:type('%s'), from:'null'() }", [key UTF8String]];
    const char *sendString = [nssendString UTF8String];
    long result = 0;

    AppleEvent sendEvent, replyEvent;

    DescType resultType;
    Size resultSize, charResultSize;

    AEBuildError buildError;
    OSStatus err;
    OSErr berr, err2, err3;
    
	if ((GetProcessPID(&psn, &pid) == noErr) && (pid == 0)) {
	    ITDebugLog(@"Error getting PID of application.");
	    return nil;
	}

    berr = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);

    [self printCarbonDesc:&sendEvent];

    if (berr) {
        ITDebugLog(@"Error: %d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[nssendString substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, /*kAEDefaultTimeout*/30, idleUPP, NULL);

    [self printCarbonDesc:&replyEvent];

    if (err) {
        ITDebugLog(@"Send Error: %i",err);
    } else {
        err2 = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);

        if (err2) {
            ITDebugLog(@"Error After AESizeOfParam: %i", err2);
        } else {
            err3 = AEGetParamPtr(&replyEvent, keyDirectObject, resultType, NULL, &result, resultSize, &charResultSize);

            if (err3) {
                ITDebugLog(@"Error After AEGetParamPtr: %i", err3);
            }
        }
    }

    if (!berr) AEDisposeDesc(&sendEvent);
    if (!err) AEDisposeDesc(&replyEvent);

    return result;
}

- (NSString*)sendTwoTierAEWithRequestedKey:(NSString*)key fromObjectByKey:(NSString*)object eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);
    int pid;

    NSString *nssendString = [NSString stringWithFormat:@"'----':obj { form:'prop', want:type('prop'), seld:type('%s'), from:obj { form:'prop', want:type('prop'), seld:type('%s'), from:'null'() } }", [key UTF8String], [object UTF8String]];
    const char *sendString = [nssendString UTF8String];
    NSString  *_finalString = nil;

    AppleEvent sendEvent, replyEvent;

    DescType resultType;
    Size resultSize, charResultSize;

    AEBuildError buildError;
    OSStatus berr,err;
    OSErr err2, err3;
    
	if ((GetProcessPID(&psn, &pid) == noErr) && (pid == 0)) {
	    ITDebugLog(@"Error getting PID of application.");
	    return nil;
	}

    berr = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);

    [self printCarbonDesc:&sendEvent];

    if (berr) {
        ITDebugLog(@"Error: %d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[nssendString substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, /*kAEDefaultTimeout*/30, idleUPP, NULL);

    [self printCarbonDesc:&replyEvent];

    if (err) {
        ITDebugLog(@"Send Error: %i",err);
    } else {
        unichar *result = 0;

        err2 = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);
        if (resultSize != 0) {
            result = malloc(resultSize);
        } else {
            return nil;
        }
        
        if (err2) {
            ITDebugLog(@"Error After AESizeOfParam: %i", err2);
        } else {
            err3 = AEGetParamPtr(&replyEvent, keyDirectObject, resultType, NULL, result, resultSize, &charResultSize);

            if (err3) {
                ITDebugLog(@"Error After AEGetParamPtr: %i", err3);
            } else {
                _finalString = [NSString stringWithCharacters:result length:charResultSize/sizeof(unichar)];
            }
        }
        free(result);
    }

    if (!berr) AEDisposeDesc(&sendEvent);
    if (!err) AEDisposeDesc(&replyEvent);

    return _finalString;
}

- (long)sendTwoTierAEWithRequestedKeyForNumber:(NSString*)key fromObjectByKey:(NSString*)object eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);

    NSString *nssendString = [NSString stringWithFormat:@"'----':obj { form:'prop', want:type('prop'), seld:type('%s'), from:obj { form:'prop', want:type('prop'), seld:type('%s'), from:'null'() } }", [key UTF8String], [object UTF8String]];
    const char *sendString = [nssendString UTF8String];
    long result = 0;

    AppleEvent sendEvent, replyEvent;
    int pid;

    DescType resultType;
    Size resultSize, charResultSize;

    AEBuildError buildError;
    OSStatus berr, err;
    OSErr err2, err3;
    
	if ((GetProcessPID(&psn, &pid) == noErr) && (pid == 0)) {
	    ITDebugLog(@"Error getting PID of application.");
	    return nil;
	}

    berr = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);

    [self printCarbonDesc:&sendEvent];

    if (berr) {
        ITDebugLog(@"Error: %d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[nssendString substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, /*kAEDefaultTimeout*/30, idleUPP, NULL);

    [self printCarbonDesc:&replyEvent];

    if (err) {
        ITDebugLog(@"Send Error: %i",err);
    } else {
        err2 = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);

        if (err2) {
            ITDebugLog(@"Error After AESizeOfParam: %i", err2);
        } else {
            err3 = AEGetParamPtr(&replyEvent, keyDirectObject, resultType, NULL, &result, resultSize, &charResultSize);

            if (err3) {
                ITDebugLog(@"Error After AEGetParamPtr: %i", err3);
            }
        }
    }

    if (!berr) AEDisposeDesc(&sendEvent);
    if (!err) AEDisposeDesc(&replyEvent);

    return result;
}

- (NSString *)sendAEWithRequestedArray:(NSArray *)array eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    NSString *buildString = [NSString stringWithFormat:@"{ form:'prop', want:type('prop'), seld:type('%s'), from:'null'() }", [[array objectAtIndex:0] UTF8String]];
    const char *sendString;
    int i;
    NSString  *_finalString = nil;
    int pid;

    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);

    AppleEvent sendEvent, replyEvent;

    DescType resultType;
    Size resultSize, charResultSize;

    AEBuildError buildError;
    OSStatus berr, err;
    OSErr err2, err3;

    for (i = 1; i < [array count]; i++) {
        NSString *from = [NSString stringWithFormat:@"{ form:'prop', want:type('prop'), seld:type('%s'), from:obj %@ }",
		  [[array objectAtIndex:i] UTF8String], buildString];
        buildString = from;
    }
    buildString = [@"'----':obj " stringByAppendingString:buildString];
    sendString = [buildString UTF8String];
    
	if ((GetProcessPID(&psn, &pid) == noErr) && (pid == 0)) {
	    ITDebugLog(@"Error getting PID of application.");
	    return nil;
	}

    berr = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);

    [self printCarbonDesc:&sendEvent];

    if (berr) {
        ITDebugLog(@"Error: %d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[buildString substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, /*kAEDefaultTimeout*/30, idleUPP, NULL);

    [self printCarbonDesc:&replyEvent];

    if (err) {
        ITDebugLog(@"Send Error: %i",err);
    } else {
        unichar *result = 0;

        err2 = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);
        if (resultSize != 0) {
            result = malloc(resultSize);
        } else {
            return nil;
        }
        if (err2) {
            ITDebugLog(@"Error After AESizeOfParam: %i", err2);
        } else {
            err3 = AEGetParamPtr(&replyEvent, keyDirectObject, resultType, NULL, result, resultSize, &charResultSize);
            if (err3) {
                ITDebugLog(@"Error After AEGetParamPtr: %i", err3);
            } else {
                _finalString = [NSString stringWithCharacters:result length:charResultSize/sizeof(unichar)];
            }
        }
        free(result);
    }
    if (!berr) AEDisposeDesc(&sendEvent);
    if (!err) AEDisposeDesc(&replyEvent);
    return _finalString;
}

- (void)sendAEWithEventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);
    AEDesc dest;
    int pid;

    AppleEvent event, reply;
    OSStatus cerr,cerr2,err;
    //AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, kAnyTransactionID, &event, nil, "");
    if ((GetProcessPID(&psn, &pid) == noErr) && (pid == 0)) {
        ITDebugLog(@"Error getting PID of application.");
	return;
    }
    cerr = AECreateDesc(typeProcessSerialNumber,(ProcessSerialNumber*)&psn,sizeof(ProcessSerialNumber),&dest);
    cerr2 = AECreateAppleEvent(eClass,eID,&dest,kAutoGenerateReturnID,kAnyTransactionID,&event);
    [self printCarbonDesc:&event];
    err = AESend(&event, &reply, kAENoReply, kAENormalPriority, /*kAEDefaultTimeout*/30, idleUPP, nil);
    [self printCarbonDesc:&reply];
    if (!cerr2) AEDisposeDesc(&dest);
    if (!cerr) AEDisposeDesc(&event);
    if (!err) AEDisposeDesc(&reply);
}

- (void)printCarbonDesc:(AEDesc*)desc {
    Handle xx;
    AEPrintDescToHandle(desc,&xx);
    ITDebugLog(@"AE Descriptor: %s", *xx);
    DisposeHandle(xx);
}


- (AEArrayDataPointer)sendAEWithRequestedKeyForArray:(NSString*)key eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID	 eID    = *((unsigned long*)[eventID UTF8String]);

    NSString *nssendString = [NSString stringWithFormat:@"'----':obj { form:'indx', want:'%s', seld:type('all '), from:'null'() }", [key UTF8String]];
    const char *sendString = [nssendString UTF8String];
    AEArrayDataPointer result = nil;
    int pid;

    AppleEvent sendEvent, replyEvent;


    AEBuildError buildError;
    OSStatus err;

if ((GetProcessPID(&psn, &pid) == noErr) && (pid == 0)) {
	    ITDebugLog(@"Error getting PID of application.");
	    return nil;
	}
    err = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);

    [self printCarbonDesc:&sendEvent];

    if (err) {
        ITDebugLog(@"Error: %d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[nssendString substringToIndex:buildError.fErrorPos]);
    }


    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, /*kAEDefaultTimeout*/30, idleUPP, NULL);

    [self printCarbonDesc:&replyEvent];

    if (err) {
        ITDebugLog(@"Send Error: %i",err);
    } else {
	   SInt32 count, resultCount;

	   AECountItems(&replyEvent,&count);
	   if ((sizeof(AEDesc)*count) != 0) {
	       result=malloc(sizeof(AEDesc)*count);
	   } else {
	       return nil;
	   }
	   AEGetArray(&replyEvent, kAEDescArray, result, sizeof(AEDesc)*count, NULL, NULL, &resultCount);

        free(result);
    }

    AEDisposeDesc(&sendEvent);
    AEDisposeDesc(&replyEvent);

    return result;
}

- (long)sendAEWithSendStringForNumber:(NSString*)string eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    //Add error checking...
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);

    const char *sendString = [string UTF8String];
    SInt32 result = 0;
    int pid;

    AppleEvent sendEvent, replyEvent;

    DescType resultType;
    Size resultSize, charResultSize;

    AEBuildError buildError;
    OSStatus berr, err;
    OSErr err2, err3;
    
	if ((GetProcessPID(&psn, &pid) == noErr) && (pid == 0)) {
	    ITDebugLog(@"Error getting PID of application.");
	    return nil;
	}

    berr = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);

    [self printCarbonDesc:&sendEvent];

    if (berr) {
        ITDebugLog(@"Error: %d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[string substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, /*kAEDefaultTimeout*/30, idleUPP, NULL);

    [self printCarbonDesc:&replyEvent];

    if (err) {
        ITDebugLog(@"Send Error: %i",err);
    } else {
        err2 = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);

        if (err2) {
            ITDebugLog(@"Error After AESizeOfParam: %i", err2);
        } else {
            err3 = AEGetParamPtr(&replyEvent, keyDirectObject, resultType, NULL, &result, resultSize, &charResultSize);

            if (err3) {
                ITDebugLog(@"Error After AEGetParamPtr: %i", err3);
            }
        }
    }


if (!berr) AEDisposeDesc(&sendEvent);
if (!err) AEDisposeDesc(&replyEvent);
ITDebugLog(@"waffles say %d",result);
return result;
}

- (AEArrayDataPointer)sendAEWithSendStringForArray:(NSString*)string eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    //Add error checking...
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);
    int pid;

    const char *sendString = [string UTF8String];
    AEArrayDataPointer result = NULL;

    AppleEvent sendEvent, replyEvent;

    AEBuildError buildError;
    OSStatus berr, err;
    
	if ((GetProcessPID(&psn, &pid) == noErr) && (pid == 0)) {
	    ITDebugLog(@"Error getting PID of application.");
	    return nil;
	}

    berr = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);

    [self printCarbonDesc:&sendEvent];

    if (berr) {
        ITDebugLog(@"Error: %d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[string substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, /*kAEDefaultTimeout*/30, idleUPP, NULL);

    [self printCarbonDesc:&replyEvent];

    if (err) {
        ITDebugLog(@"Send Error: %i",err);
    } else {
        SInt32 count, resultCount;
        
        AECountItems(&replyEvent,&count);
        if ((sizeof(AEDesc)*count) != 0) {
	       result=malloc(sizeof(AEDesc)*count);
        } else {
	       return nil;
        }
        AEGetArray(&replyEvent, kAEDescArray, result, sizeof(AEDesc)*count, NULL, NULL, &resultCount);
        
        free(result);
    }

    if (!berr) AEDisposeDesc(&sendEvent);
    if (!err) AEDisposeDesc(&replyEvent);

    return result;
}

- (NSData*)sendAEWithSendStringForData:(NSString*)nssendString eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    //Add error checking...
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID	 eID    = *((unsigned long*)[eventID UTF8String]);
    int pid;
    
    const char *sendString = [nssendString UTF8String];
    NSData  *_finalData = nil;
    
    AppleEvent sendEvent, replyEvent;
    
    DescType resultType;
    Size resultSize, charResultSize;
    
    AEBuildError buildError;
    OSStatus berr,err;
    OSErr err2, err3;
    
    if ((GetProcessPID(&psn, &pid) == noErr) && (pid == 0)) {
	ITDebugLog(@"Error getting PID of application.");
	return nil;
    }
    
    berr = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);
    if (!berr) [self printCarbonDesc:&sendEvent];
    
    if (berr) {
        ITDebugLog(@"Error: %d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[nssendString substringToIndex:buildError.fErrorPos]);
    }
    
    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, /*kAEDefaultTimeout*/30, idleUPP, NULL);
    if (!err) [self printCarbonDesc:&replyEvent];
    
    if (err) {
        ITDebugLog(@"Send Error: %i",err);
    } else {
        unichar *result = 0;
	
        err2 = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);
        if (resultSize != 0) {
            result = malloc(resultSize);
        } else {
            return nil;
        }
	
        if (err2) {
            ITDebugLog(@"Error After AESizeOfParam: %i", err2);
        } else {
            err3 = AEGetParamPtr(&replyEvent, keyDirectObject, resultType, NULL, result, resultSize, &charResultSize);
	    
            if (err3) {
                ITDebugLog(@"Error After AEGetParamPtr: %i", err3);
            } else {
                _finalData = [NSData dataWithBytesNoCopy:result length:charResultSize freeWhenDone:YES];
            }
        }
    }
    
    if (!berr) AEDisposeDesc(&sendEvent);
    if (!err) AEDisposeDesc(&replyEvent);
    
    return _finalData;
}

@end