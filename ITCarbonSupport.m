#import "ITCarbonSupport.h"

NSString *NSStringFromFourCharCode(FourCharCode code) {
    return [NSString stringWithUTF8String:&code];
}

FourCharCode FourCharCodeFromNSString(NSString *string) {
    return (*((unsigned long*)[string UTF8String]));
}