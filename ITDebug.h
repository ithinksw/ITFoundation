/*
 *	ITFoundation
 *	ITDebug.h
 *
 *	Functions for logging debugging information intelligently.
 *
 *	Copyright (c) 2005 by iThink Software.
 *	All Rights Reserved.
 *
 *	$Id$
 *
 */

#import <Foundation/Foundation.h>

void SetITDebugMode(BOOL mode);
void ITDebugLog(NSString *format, ...);