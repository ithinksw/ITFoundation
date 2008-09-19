#import "ITCategory-NSData.h"
#import <openssl/md5.h>
#import <openssl/sha.h>

@implementation NSData (ITFoundationCategory)

- (NSString *)hexadecimalRepresentation {
	int dataLength = [self length];
	int stringLength = dataLength * 2;
	
	char *dataBytes = [self bytes];
	char hexString[stringLength];
	
	int i;
	for (i=0; i < dataLength; i++) {
		sprintf(hexString + (i * 2), "%02x", dataBytes[i]);
	}
	
	return [NSString stringWithCString:hexString length:stringLength];
}

- (NSData *)MD5 {
	int length = 16;
	unsigned char digest[length];
	MD5([self bytes], [self length], digest);
	return [NSData dataWithBytes:&digest length:length];
}

- (NSData *)SHA1 {
	int length = 20;
	unsigned char digest[length];
	SHA1([self bytes], [self length], digest);
	return [NSData dataWithBytes:&digest length:length];
}

@end
