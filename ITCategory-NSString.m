#import "ITCategory-NSString.h"

@implementation NSString (ITFoundationCategory)

+ (id)stringWithFourCharCode:(unsigned long)fourCharCode {
	return [[[self alloc] initWithFourCharCode:fourCharCode] autorelease];
}

- (id)initWithFourCharCode:(unsigned long)fourCharCode {
	return [self initWithFormat:@"%.4s", &fourCharCode];
}

- (unsigned long)fourCharCode {
	const unsigned char *c_s = [self UTF8String];
	unsigned long tmp = *c_s++;
	tmp <<= 8;
	tmp |= *c_s++;
	tmp <<= 8;
	tmp |= *c_s++;
	tmp <<= 8;
	return tmp |= *c_s++;
}

@end