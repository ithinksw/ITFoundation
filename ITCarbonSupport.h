/*
 *	ITFoundation
 *	ITCarbonSupport.h
 *
 *	Utility functions to convert between FourCharCodes/OSTypes/ResTypes and
 *		NSStrings.
 *
 *	Copyright (c) 2005 by iThink Software.
 *	All Rights Reserved.
 *
 *	$Id$
 *
 */

#import <Foundation/Foundation.h>

NSString *NSStringFromFourCharCode(unsigned long code);
unsigned long FourCharCodeFromNSString(NSString *string);