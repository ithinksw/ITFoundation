#import "ITCarbonSupport.h"

NSString *NSStringFromFourCharCode(unsigned long code) {
    return [NSString stringWithUTF8String:&code];
}

unsigned long FourCharCodeFromNSString(NSString *string) {
    return (*((unsigned long*)[string UTF8String]));
}