/*
 *	ITFoundation
 *	ITCategory-NSArray.h
 *
 *	Copyright (c) 2005 by iThink Software.
 *	All Rights Reserved.
 *
 *	$Id$
 *
 */

#import <Foundation/Foundation.h>

@interface NSArray (ITFoundationCategory)

- (NSArray *)objectsForKey:(NSString *)key;
- (BOOL)containsString:(NSString *)string;

@end