/*
 *  ITAppleEventTools.c
 *  ITFoundation
 *
 *  Created by Alexander Strange on Wed Feb 11 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */

#import "ITDebug.h"
#import "ITAppleEventTools.h"

NSAppleEventDescriptor *ITSendAEWithString(NSString *sendString, FourCharCode evClass, FourCharCode evID,const ProcessSerialNumber *psn)
{
    //Add error checking...
    pid_t pid;
    
    const char *usendString = [sendString UTF8String];
    
    AppleEvent sendEvent, replyEvent;
    NSAppleEventDescriptor *send, *recv;
    AEDesc resultDesc;
    DescType resultType;
    Size resultSize;
    
    AEBuildError buildError;
    OSStatus berr,err;
    
    if ((GetProcessPID(psn, &pid) == noErr) && (pid == 0)) {
	ITDebugLog(@"Error getting PID of application.");
	return nil;
    }
    
    berr = AEBuildAppleEvent(evClass, evID, typeProcessSerialNumber,psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, usendString);
    send = [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&sendEvent] autorelease];
    if (!berr) [send logDesc];
    
    if (berr) {
        ITDebugLog(@"Error: %d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[sendString substringToIndex:buildError.fErrorPos]);
    }
    
    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, /*kAEDefaultTimeout*/60, NULL, NULL);
    
    err = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);
    if (resultSize == 0 || err != 0) {
        return nil;
    }
    
    AEGetParamDesc(&replyEvent, keyDirectObject, resultType, &resultDesc);
    
    recv = [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&resultDesc] autorelease];
    [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&replyEvent] autorelease];
    if (!err) [recv logDesc];
    
    if (err) {
        ITDebugLog(@"Send Error: %i",err);
    }
    return recv;
}

NSAppleEventDescriptor *ITSendAEWithStringAndObject(NSString *sendString, const AEDesc *object, FourCharCode evClass, FourCharCode evID,const ProcessSerialNumber *psn)
{
    //Add error checking...
    pid_t pid;
    
    const char *usendString = [sendString UTF8String];
    
    AppleEvent sendEvent, replyEvent;
    NSAppleEventDescriptor *send, *recv;
    AEDesc resultDesc;
    DescType resultType;
    Size resultSize;
    
    AEBuildError buildError;
    OSStatus berr,err;
    
    if ((GetProcessPID(psn, &pid) == noErr) && (pid == 0)) {
	ITDebugLog(@"Error getting PID of application.");
	return nil;
    }
    
    berr = AEBuildAppleEvent(evClass, evID, typeProcessSerialNumber,psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, usendString);
    send = [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&sendEvent] autorelease];
    if (!berr) [send logDesc];
    
    if (berr) {
        ITDebugLog(@"Error: %d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[sendString substringToIndex:buildError.fErrorPos]);
    }
    err = AEPutParamDesc(&sendEvent, keyDirectObject, object);
    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, /*kAEDefaultTimeout*/60, NULL, NULL);
    
    err = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);
    if (resultSize == 0 || err != 0) {
        return nil;
    }
    
    AEGetParamDesc(&replyEvent, keyDirectObject, resultType, &resultDesc);
    
    recv = [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&resultDesc] autorelease];
    [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&replyEvent] autorelease];
    if (!err) [recv logDesc];
    
    if (err) {
        ITDebugLog(@"Send Error: %i",err);
    }
    return recv;
}

NSAppleEventDescriptor *ITSendAEWithKey(FourCharCode reqKey, FourCharCode evClass, FourCharCode evID,const ProcessSerialNumber *psn)
{
    //Add error checking...
    pid_t pid;
	NSString *sendString = [NSString stringWithFormat:@"'----':obj { form:'prop', want:type('prop'), seld:type('%c%c%c%c'), from:'null'() }", (reqKey >> 24), (reqKey >> 16) & 0xff, (reqKey >> 8) & 0xff, reqKey & 0xff];
    const char *usendString = [sendString UTF8String];
    
    AppleEvent sendEvent, replyEvent;
    NSAppleEventDescriptor *send, *recv;
    AEDesc resultDesc;
    DescType resultType;
    Size resultSize;
    
    AEBuildError buildError;
    OSStatus berr,err;
    
    if ((GetProcessPID(psn, &pid) == noErr) && (pid == 0)) {
	ITDebugLog(@"Error getting PID of application.");
	return nil;
    }
    
    berr = AEBuildAppleEvent(evClass, evID, typeProcessSerialNumber,psn, sizeof(ProcessSerialNumber), kAutoGenerateReturnID, 0, &sendEvent, &buildError, usendString);
    send = [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&sendEvent] autorelease];
    if (!berr) [send logDesc];
    
    if (berr) {
        ITDebugLog(@"Error: %d:%d at \"%@\"",(int)buildError.fError,buildError.fErrorPos,[sendString substringToIndex:buildError.fErrorPos]);
    }
    
    err = AESend(&sendEvent, &replyEvent, kAEWaitReply, kAENormalPriority, /*kAEDefaultTimeout*/60, NULL, NULL);
    
    err = AESizeOfParam(&replyEvent, keyDirectObject, &resultType, &resultSize);
    if (resultSize == 0 || err != 0) {
        return nil;
    }
    
    AEGetParamDesc(&replyEvent, keyDirectObject, resultType, &resultDesc);
    
    recv = [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&resultDesc] autorelease];
    [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&replyEvent] autorelease];
    if (!err) [recv logDesc];
    
    if (err) {
        ITDebugLog(@"Send Error: %i",err);
    }
    return recv;
}

NSAppleEventDescriptor *ITSendAE(FourCharCode eClass, FourCharCode eID,const ProcessSerialNumber *psn)
{
    AEDesc dest;
    int pid;
    
    AppleEvent event, reply;
    OSStatus cerr,cerr2,err;
    NSAppleEventDescriptor *nsd, *nse, *nsr;
    if ((GetProcessPID(psn, &pid) == noErr) && (pid == 0)) {
        ITDebugLog(@"Error getting PID of application.");
	return nil;
    }
    cerr = AECreateDesc(typeProcessSerialNumber,psn,sizeof(ProcessSerialNumber),&dest);
    nsd = [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&dest] autorelease];
    cerr2 = AECreateAppleEvent(eClass,eID,&dest,kAutoGenerateReturnID,kAnyTransactionID,&event);
    nse = [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&event] autorelease];
    if (!cerr2) [nse logDesc];
    err = AESend(&event, &reply, kAENoReply, kAENormalPriority, /*kAEDefaultTimeout*/60, NULL, NULL);
    nsr = [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&reply] autorelease];
    [nsr logDesc];
    return nsr;
}

@implementation NSAppleEventDescriptor (ITAELogging)
-(void) logDesc
{
    Handle xx;
    AEPrintDescToHandle([self aeDesc],&xx);
    ITDebugLog(@"AE Descriptor: %s", *xx);
    DisposeHandle(xx);
}
@end