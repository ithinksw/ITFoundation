#import "ITThreadChild.h"

@implementation ITThreadChild

+ (void)runWithPorts:(NSArray *)portArray {
	NSAutoreleasePool *pool;
	NSConnection *parentConnection;
	id childObject;
	
	pool = [[NSAutoreleasePool alloc] init];
	
	parentConnection = [NSConnection connectionWithReceivePort:[portArray objectAtIndex:0] sendPort:[portArray objectAtIndex:1]];
	
	childObject = [self alloc];
	if ([(id <ITThreadParent>)[parentConnection rootProxy] registerThreadedChild:childObject]) {
		[[NSRunLoop currentRunLoop] run];
	}
	
	[childObject release];
	[pool release];
}

@end
