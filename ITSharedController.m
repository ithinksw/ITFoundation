#import "ITSharedController.h"

static NSMutableDictionary *_ITSharedController_sharedControllers = nil;

@implementation ITSharedController

+ (id)sharedController {
	if (!_ITSharedController_sharedControllers) {
		_ITSharedController_sharedControllers = [[NSMutableDictionary alloc] init];
	}
	id thisController;
	if (thisController = [_ITSharedController_sharedControllers objectForKey:NSStringFromClass(self)]) {
		return thisController;
	} else {
		thisController = [[self alloc] init];
		[_ITSharedController_sharedControllers setObject:thisController forKey:NSStringFromClass(self)];
		return thisController;
	}
}

@end
