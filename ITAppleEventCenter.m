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

- (id)init
{
    if (self = [super init])
	   {
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

    NSString *nssendString = [NSString stringWithFormat:@"'----':obj { form:'prop', want:type('prop'), seld:type('%s'), from:'null'() }", [key UTF8String]];
    const char *sendString = [nssendString UTF8String];
    NSString  *_finalString = nil;

    AppleEvent sendEvent, replyEvent;

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

    [self printCarbonDesc:&sendEvent];

    if (err) {
        NSLog(@"%d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[nssendString substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, kNoTimeOut, idleUPP, NULL);

    [self printCarbonDesc:&replyEvent];

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
                _finalString = [NSString stringWithCharacters:result length:charResultSize/sizeof(unichar)];
            }
        }
        free(result);
    }

    AEDisposeDesc(&sendEvent);
    AEDisposeDesc(&replyEvent);

    return _finalString;
}

- (NSString*)sendAEWithSendString:(NSString*)nssendString eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    //Add error checking...
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID	 eID    = *((unsigned long*)[eventID UTF8String]);

    const char *sendString = [nssendString UTF8String];
    NSString  *_finalString = nil;

    AppleEvent sendEvent, replyEvent;

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

    [self printCarbonDesc:&sendEvent];

    if (err) {
        NSLog(@"%d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[nssendString substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, kNoTimeOut, idleUPP, NULL);

    [self printCarbonDesc:&replyEvent];

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
                _finalString = [NSString stringWithCharacters:result length:charResultSize/sizeof(unichar)];
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

    NSString *nssendString = [NSString stringWithFormat:@"'----':obj { form:'prop', want:type('prop'), seld:type('%s'), from:'null'() }", [key UTF8String]];
    const char *sendString = [nssendString UTF8String];
    long result = 0;

    AppleEvent sendEvent, replyEvent;

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

    [self printCarbonDesc:&sendEvent];

    if (err) {
        NSLog(@"%d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[nssendString substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, kNoTimeOut, idleUPP, NULL);

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

    NSString *nssendString = [NSString stringWithFormat:@"'----':obj { form:'prop', want:type('prop'), seld:type('%s'), from:obj { form:'prop', want:type('prop'), seld:type('%s'), from:'null'() } }", [key UTF8String], [object UTF8String]];
    const char *sendString = [nssendString UTF8String];
    NSString  *_finalString = nil;

    AppleEvent sendEvent, replyEvent;

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

    [self printCarbonDesc:&sendEvent];

    if (err) {
        NSLog(@"%d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[nssendString substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, kNoTimeOut, idleUPP, NULL);

    [self printCarbonDesc:&replyEvent];

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
                _finalString = [NSString stringWithCharacters:result length:charResultSize/sizeof(unichar)];
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

    NSString *nssendString = [NSString stringWithFormat:@"'----':obj { form:'prop', want:type('prop'), seld:type('%s'), from:obj { form:'prop', want:type('prop'), seld:type('%s'), from:'null'() } }", [key UTF8String], [object UTF8String]];
    const char *sendString = [nssendString UTF8String];
    long result = 0;

    AppleEvent sendEvent, replyEvent;

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

    [self printCarbonDesc:&sendEvent];

    if (err) {
        NSLog(@"%d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[nssendString substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, kNoTimeOut, idleUPP, NULL);

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

    [self printCarbonDesc:&sendEvent];

    if (err) {
        NSLog(@"%d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[buildString substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, kNoTimeOut, idleUPP, NULL);

    [self printCarbonDesc:&replyEvent];

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
                _finalString = [NSString stringWithCharacters:result length:charResultSize/sizeof(unichar)];
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
[self printCarbonDesc:&event];
    AESend(&event, &reply, kAENoReply, kAENormalPriority, kAEDefaultTimeout, idleUPP, nil);
[self printCarbonDesc:&reply];
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

    NSString *nssendString = [NSString stringWithFormat:@"'----':obj { form:'indx', want:'%s', seld:abso($616C6C20$), from:'null'() }", [key UTF8String]];
    const char *sendString = [nssendString UTF8String];
    AEArrayDataPointer result = nil;

    AppleEvent sendEvent, replyEvent;


    AEBuildError buildError;
    OSStatus err;

    //NSLog(@"_sendString: %s", sendString);

    err = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);

    [self printCarbonDesc:&sendEvent];

    if (err) {
        NSLog(@"%d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[nssendString substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, kNoTimeOut, idleUPP, NULL);

    [self printCarbonDesc:&replyEvent];

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

- (long)sendAEWithSendStringForNumber:(NSString*)string eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    //Add error checking...
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);

    const char *sendString = [string UTF8String];
    SInt32 result = 0;

    AppleEvent sendEvent, replyEvent;

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

    [self printCarbonDesc:&sendEvent];

    if (err) {
        NSLog(@"%d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[string substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, kNoTimeOut, idleUPP, NULL);

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
            }
        }
    }


AEDisposeDesc(&sendEvent);
AEDisposeDesc(&replyEvent);
NSLog(@"waffles say %d",result);
return result;
}

- (AEArrayDataPointer)sendAEWithSendStringForArray:(NSString*)string eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn
{
    //Add error checking...
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);

    const char *sendString = [string UTF8String];
    AEArrayDataPointer result = NULL;

    AppleEvent sendEvent, replyEvent;

    AEBuildError buildError;
    OSStatus err;
    /*
	if ((GetProcessPID(&psn, &pid) == noErr) && (pid == 0)) {
	    NSLog(@"Error getting PID of application! Exiting.");
	    return nil;
	}
	*/
    //NSLog(@"_sendString: %s", sendString);

    err = AEBuildAppleEvent(eClass, eID, typeProcessSerialNumber,(ProcessSerialNumber*)&psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, sendString);

    [self printCarbonDesc:&sendEvent];

    if (err) {
        NSLog(@"%d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[string substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, kNoTimeOut, idleUPP, NULL);

    [self printCarbonDesc:&replyEvent];

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
- (long)sendAEWithSendStringForNumber:(NSString*)string eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn fixForAECrappiness:(long)fix
{
    //Add error checking...
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);

    const char *sendString = [string UTF8String];
    SInt32 result = 0;

    AppleEvent sendEvent, replyEvent;

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
[self printCarbonDesc:&sendEvent];
	//now AEBuildAppleEvent has inserted a bogus integer in there for no reason, so we fix it ourselves.
	{ //this sucks
//hey, i'm coding this in pico, sccrew indention
char *buf;
Size s,i;
s = AESizeOfFlattenedDesc(&sendEvent);
buf = malloc(s);
AEFlattenDesc(&sendEvent,buf,s,NULL);	
AEDisposeDesc(&sendEvent);
for (i=0;i<s;i++)
{
long *lbuf = &(buf[i]);
if (s-i <= 8) break; //is there enough room left?
if (*lbuf == 'long' || *lbuf=='magn')
{
lbuf = &(buf[i+4]);
*lbuf = fix;
}
}
//sendEvent = NULL;
AEUnflattenDesc(buf,&sendEvent);
free(buf);
}


    [self printCarbonDesc:&sendEvent];

    if (err) {
        NSLog(@"%d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[string substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, kNoTimeOut, idleUPP, NULL);

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
            }
        }
    }


AEDisposeDesc(&sendEvent);
AEDisposeDesc(&replyEvent);
NSLog(@"waffles say %d",result);
return result;
}

- (NSString*)sendAEWithSendString:(NSString*)nssendString eventClass:(NSString*)eventClass eventID:(NSString*)eventID appPSN:(ProcessSerialNumber)psn fixForAECrappiness:(long)fix
{
    //Add error checking...
    AEEventClass eClass = *((unsigned long*)[eventClass UTF8String]);
    AEEventID    eID    = *((unsigned long*)[eventID UTF8String]);

    const char *sendString = [nssendString UTF8String];
    NSString  *_finalString = nil;

    AppleEvent sendEvent, replyEvent;

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
[self printCarbonDesc:&sendEvent];
        //now AEBuildAppleEvent has inserted a bogus integer in there for no reason, so we fix it ourselves.
{ //this sucks
//hey, i'm coding this in pico, sccrew indention
Size s;
AEDesc dirObj;
long tmp;
AEKeyword a;
AESizeOfParam(&sendEvent,'from',&a,&s);
//AEDeleteParam(&sendEvent,'seld');
//AEPutParamPtr(&sendEvent,'seld','long',&fix,sizeof(fix));
AEGetParamDesc(&sendEvent,'from',a,&dirObj);
AEGetParamPtr(&dirObj,'seld','long',&a,&tmp,4,&s);
{
char *x = (char*)&a;
	NSLog(@"the seld: %lu of type %c%c%c%c len %lu",tmp,x[0],x[1],x[2],x[3],s);
}
AEDisposeDesc(&dirObj);
}
    [self printCarbonDesc:&sendEvent];

    if (err) {
        NSLog(@"%d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[nssendString substringToIndex:buildError.fErrorPos]);
    }

    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, kNoTimeOut, idleUPP, NULL);

    [self printCarbonDesc:&replyEvent];

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
                _finalString = [NSString stringWithCharacters:result length:charResultSize/sizeof(unichar)];
            }
        }
        free(result);
    }

    AEDisposeDesc(&sendEvent);
    AEDisposeDesc(&replyEvent);

    return _finalString;
}
@end
