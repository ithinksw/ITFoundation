#import "ITCategory-NSString.h"
#import "ITCategory-NSData.h"

@implementation NSString (ITFoundationCategory)

+ (id)stringWithFourCharCode:(unsigned long)fourCharCode {
	return [[[self alloc] initWithFourCharCode:fourCharCode] autorelease];
}

- (id)initWithFourCharCode:(unsigned long)fourCharCode {
	return [self initWithString:(NSString *)UTCreateStringForOSType(fourCharCode)];
	//return [self initWithFormat:@"%.4s", &fourCharCode];
}

- (unsigned long)fourCharCode {
	return UTGetOSTypeFromString((CFStringRef)self);
	
	//Die nasty bitshifting
	/*const unsigned char *c_s = [self UTF8String];
	unsigned long tmp = *c_s++;
	tmp <<= 8;
	tmp |= *c_s++;
	tmp <<= 8;
	tmp |= *c_s++;
	tmp <<= 8;
	return tmp |= *c_s++;*/
}

- (NSData *)MD5 {
	return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] MD5];
}

- (NSData *)SHA1 {
	return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] SHA1];
}

@end