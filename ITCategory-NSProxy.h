/*
 *	ITFoundation
 *	ITCategory-NSProxy.h
 *
 *	This is actually a bug fix, as _copyDescription is required by NSLog when
 *		you supply an object other than a string as a parameter for building a
 *		string, and yet NSProxy does not implement or proxy it.
 *
 *	Copyright (c) 2005 by iThink Software.
 *	All Rights Reserved.
 *
 *	$Id$
 *
 */

#import <Cocoa/Cocoa.h>

@interface NSProxy (ITCategory)

- (NSString *)_copyDescription;

@end
