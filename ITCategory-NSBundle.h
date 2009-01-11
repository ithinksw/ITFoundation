/*
 *	ITFoundation
 *	ITCategory-NSBundle.h
 *
 *	Copyright (c) 2005 iThink Software
 *
 */

#import <Foundation/Foundation.h>

@interface NSBundle (ITFoundationCategory)

+ (NSBundle *)bundleForFrameworkWithIdentifier:(NSString *)frameworkIdentifier;

@end