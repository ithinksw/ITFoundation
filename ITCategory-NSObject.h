/*
 *	ITKit
 *  ITCategory-NSObject.h
 *    Category which extends NSObject
 *
 *  Original Author : Joseph Spiros <joseph.spiros@ithinksw.com>
 *   Responsibility : Joseph Spiros <joseph.spiros@ithinksw.com>
 *
 *  Copyright (c) 2002 - 2004 iThink Software.
 *  All Rights Reserved
 *
 */


#import <Cocoa/Cocoa.h>


@interface NSObject (ITCategory)

+ (NSArray *)subclasses;
+ (NSArray *)directSubclasses;


@end
