#import "ITUUID.h"

NSString *ITUUID() {
	CFUUIDRef newUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, newUUID);
	CFRelease(newUUID);
	return [(NSString *)string autorelease];
}
