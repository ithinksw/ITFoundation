#import "ITCarbonSupport.h"

NSString *NSStringFromFourCharCode(unsigned long code) {
	return [NSString stringWithFormat:@"%.4s", &code];
}

unsigned long FourCharCodeFromNSString(NSString *string) {
	const unsigned char *c_s = [string UTF8String];
    unsigned long tmp = *c_s++;
    tmp <<= 8;
    tmp |= *c_s++;
    tmp <<= 8;
    tmp |= *c_s++;
    tmp <<= 8;
    return tmp |= *c_s++;
}