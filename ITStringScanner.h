/*
 *	ITFoundation
 *	ITStringScanner
 *	  A super-fast replacement for NSScanner
 *
 *	Original Author	: Alexander Strange <alexander.strange@ithinksw.com>
 *   Responsibility : Matt Judy <mjudy@ithinksw.com>
 *   Responsibility : Alexander Strange <alexander.strange@ithinksw.com>
 *
 *	Copyright (c) 2002 - 2003 iThink Software.
 *	All Rights Reserved
 *
 */

#import <Foundation/Foundation.h>
#import <stdlib.h>

/*!
@class ITStringScanner
@discussion A super-fast replacement for NSScanner
*/

@interface ITStringScanner : NSObject {
    NSString *_string;
    char *_cString;
    size_t _currentPosition;
    size_t _size;
}
- (id)initWithString:(NSString*)string;
- (NSString *)scanUpToCharacter:(char)character;
- (NSString *)scanUpToString:(NSString*)string;
@end
