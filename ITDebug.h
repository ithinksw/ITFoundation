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

extern void SetITDebugMode(BOOL mode);
extern void ITDebugLog(NSString *format, ...);