/*
 *	ITFoundation
 *	ITCategory-NSObject.h
 *
 *	Copyright (c) 2005 by iThink Software.
 *	All Rights Reserved.
 *
 *	$Id$
 *
 */

#import <Foundation/Foundation.h>

@interface NSObject (ITFoundationCategory)

+ (NSArray *)subclasses;
+ (NSArray *)directSubclasses;

@end