/*
 *	ITFoundation
 *	ITCategory-NSString.h
 *
 *	Copyright (c) 2005 by iThink Software.
 *	All Rights Reserved.
 *
 *	$Id$
 *
 */

#import <Foundation/Foundation.h>

@interface NSString (ITFoundationCategory)

+ (id)stringWithFourCharCode:(unsigned long)fourCharCode;

- (id)initWithFourCharCode:(unsigned long)fourCharCode;
- (unsigned long)fourCharCode;

- (NSData *)MD5;
- (NSData *)SHA1;

@end