/*
 *  ITDebug.m
 *  ITFoundation
 *
 *  Created by Joseph Spiros on Fri Sep 12 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */

#import "ITDebug.h"

static BOOL _ITDebugMode = YES;

void SetITDebugMode (BOOL mode)
{
    _ITDebugMode = mode;
}

void ITDebugLog (NSString *format, ...)
{
    if ( ( _ITDebugMode == YES ) ) {
        va_list ap;
    
        va_start (ap, format);
        NSLogv (format, ap);
        va_end (ap);
    }
}