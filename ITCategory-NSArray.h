/*
 *	ITKit
 *  ITCategory-NSArray.h
 *    Category which extends NSArray
 *
 *  Original Author : Joseph Spiros <joseph.spiros@ithinksw.com>
 *   Responsibility : Matt Judy <mjudy@ithinksw.com>
 *   Responsibility : Joseph Spiros <joseph.spiros@ithinksw.com>
 *
 *  Copyright (c) 2002 - 2003 iThink Software.
 *  All Rights Reserved
 *
 */


#import <Cocoa/Cocoa.h>


@interface NSArray (ITCategory)

- (NSArray *)objectsForKey:(NSString *)key;
- (BOOL)containsString:(NSString *)string;


@end
