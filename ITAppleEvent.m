#import "ITAppleEvent.h"


@implementation ITAppleEvent


- (id)initWithOSASource:(NSString *)source
{
}
- (id)initWithOSACompiledData:(NSData *)data
{
}
- (id)initWithOSAFromContentsOfURL:(NSURL *)url
{
}
- (id)initWithOSAFromContentsOfPath:(NSString *)path
{
}
- (id)initWithAppleEventClass:(AEEventClass)eventClass appleEventID:(AEEventID)eventID
{
    OSType AppType = eventClass;
    AEBuildAppleEvent(eventClass, eventID, typeApplSignature, &AppType, sizeof(AppType), kAutoGenerateReturnID, kAnyTransactionID, &event, nil, "");
}
- (NSString *)OSASource
{
}
- (void)setOSASource:(NSString *)source
{
}
- (NSData *)OSACompiledData
{
}
- (void)setOSACompiledData:(NSData *)data
{
}
- (AEEventClass)appleEventClass
{
}
- (AEEventID)appleEventID
{
}
- (NSString *)execute
{
    AESend(&event, &reply, kAENoReply, kAENormalPriority, kAEDefaultTimeout, nil, nil);
    // AEDisposeDesc(&event);
    // AEDisposeDesc(&reply);
}

@end
