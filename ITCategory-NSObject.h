/*
 *	ITFoundation
 *	ITCategory-NSObject.h
 *
 *	Copyright (c) 2005 iThink Software
 *
 */

#import <Foundation/Foundation.h>

@interface NSObject (ITFoundationCategory)

+ (NSArray *)subclasses;
+ (NSArray *)directSubclasses;

@end