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

- (NSString *)hexadecimalRepresentation;

- (NSData *)MD5;
- (NSData *)SHA1;

@end
