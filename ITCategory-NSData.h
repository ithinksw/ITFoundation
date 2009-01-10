/*
 *	ITFoundation
 *	ITCategory-NSData.h
 *
 *	Copyright (c) 2008 by iThink Software.
 *	All Rights Reserved.
 *
 *	$Id$
 *
 */

#import <Foundation/Foundation.h>

@interface NSData (ITFoundationCategory)

+ (id)dataWithBase64:(NSString *)base64;
- (id)initWithBase64:(NSString *)base64;

- (NSString *)hexadecimalRepresentation;

- (NSString *)base64;
- (NSData *)MD5;
- (NSData *)SHA1;

@end
