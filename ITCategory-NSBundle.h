/*
 *	ITFoundation
 *	ITCategory-NSBundle.h
 *
 *	Copyright (c) 2005 by iThink Software.
 *	All Rights Reserved.
 *
 *	$Id$
 *
 */

#import <Foundation/Foundation.h>

@interface NSBundle (ITFoundationCategory)

+ (NSBundle *)bundleForFrameworkWithIdentifier:(NSString *)frameworkIdentifier;

@end