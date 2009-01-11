/*
 *	ITFoundation
 *	ITCarbonSupport.h
 *
 *	Utility functions to convert between FourCharCodes/OSTypes/ResTypes and
 *		NSStrings. These only call through to the methods implemented by
 *		the ITFoundationCategory on NSString, and those methods are recommended
 *		for all new projects needing this functionality.
 *
 *	Copyright (c) 2005 iThink Software
 *
 */

#import <Foundation/Foundation.h>

extern NSString *NSStringFromFourCharCode(unsigned long code);
extern unsigned long FourCharCodeFromNSString(NSString *string);