#import "ITCategory-NSProxy.h"

@implementation NSProxy (ITCategory)

- (NSString *)_copyDescription {
	return [[self description] retain];
}

@end
