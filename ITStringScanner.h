/*
 *	ITFoundation
 *	ITStringScanner
 *
 *	A super-fast replacement for NSScanner
 *
 *	Original Author	: Alexander Strange <alexander.strange@ithinksw.com>
 *	Responsibility	: Alexander Strange <alexander.strange@ithinksw.com>
 *			: Joseph Spiros <joseph.spiros@ithinksw.com>
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
    NSString *str;
    char *strCStr;
    size_t curPos;
    size_t size;
}
-(id)initWithString:(NSString*)str2;
-(NSString *)scanUpToCharacter:(char)c;
-(NSString *)scanUpToString:(NSString*)str;
@end
