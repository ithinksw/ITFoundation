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

#import <Cocoa/Cocoa.h>

@interface NSBundle (ITCategory)

+ (NSBundle *)bundleForFrameworkWithIdentifier:(NSString *)frameworkIdentifier;

@end
