#import "ITCarbonSupport.h"

NSString *NSStringFromFourCharCode(unsigned long code) {
	return [NSString stringWithUTF8String:(const char *)&code];
}

unsigned long FourCharCodeFromNSString(NSString *string) {
	return (*((unsigned long*)[string UTF8String]));
}