/*
 *  ITLoginItem.h
 *  ITFoundation
 *
 *  Created by Kent Sutherland on Mon May 17 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */

#import <Carbon/Carbon.h>
#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

//These functions check for a match with just the lastPathComponent, so it will handle people moving the app
void ITSetApplicationLaunchOnLogin(NSString *path, BOOL flag);
BOOL ITDoesApplicationLaunchOnLogin(NSString *path); 