#import "ITCategory-NSProxy.h"

@implementation NSProxy (ITFoundationCategory)

- (NSString *)_copyDescription {
	return [[self description] retain];
}

@end