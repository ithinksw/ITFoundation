#import "ITCarbonSupport.h"
#import "ITCategory-NSString.h"

NSString *NSStringFromFourCharCode(unsigned long code) {
	return [NSString stringWithFourCharCode:code];
}

unsigned long FourCharCodeFromNSString(NSString *string) {
	return [string fourCharCode];
}