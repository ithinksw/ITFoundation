/*
 *  ITDebug.h
 *  ITFoundation
 *
 *  Created by Joseph Spiros on Fri Sep 12 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

void SetITDebugMode(BOOL mode);
void ITDebugLog(NSString *format, ...);
