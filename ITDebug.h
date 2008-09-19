/*
 *	ITFoundation
 *	ITDebug.h
 *
 *	Functions for logging debugging information intelligently.
 *
 *	Copyright (c) 2008 by iThink Software.
 *	All Rights Reserved.
 *
 *	$Id$
 *
 */

#import <Foundation/Foundation.h>

extern NSString *ITDebugErrorPrefixForObject(id object);
extern BOOL ITDebugMode();
extern void SetITDebugMode(BOOL mode);
extern void ITDebugLog(NSString *format, ...);