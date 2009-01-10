#import "ITCategory-NSData.h"
#import <openssl/bio.h>
#import <openssl/evp.h>
#import <openssl/md5.h>
#import <openssl/sha.h>

@implementation NSData (ITFoundationCategory)

+ (id)dataWithBase64:(NSString *)base64 {
	return [[[self alloc] initWithBase64:base64] autorelease];
}

- (id)initWithBase64:(NSString *)base64 {
	BIO *mem = BIO_new_mem_buf((void *)[base64 cString], [base64 cStringLength]);
	BIO *b64 = BIO_new(BIO_f_base64());
	BIO_set_flags(b64, BIO_FLAGS_BASE64_NO_NL);
	mem = BIO_push(b64, mem);

	NSMutableData *data = [NSMutableData data];
	char inbuf[512];
	int inlen;
	while ((inlen = BIO_read(mem, inbuf, sizeof(inbuf))) > 0) {
		[data appendBytes:inbuf length:inlen];
	}

	BIO_free_all(mem);
	return [self initWithData:data];
}

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

- (NSString *)base64 {
	BIO *mem = BIO_new(BIO_s_mem());
    BIO *b64 = BIO_new(BIO_f_base64());
	BIO_set_flags(b64, BIO_FLAGS_BASE64_NO_NL);
	mem = BIO_push(b64, mem);
    
    BIO_write(mem, [self bytes], [self length]);
    BIO_flush(mem);
    
    char *base64Char;
    long base64Length = BIO_get_mem_data(mem, &base64Char);
    NSString *base64String = [NSString stringWithCString:base64Char length:base64Length];
    
    BIO_free_all(mem);
    return base64String;
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
