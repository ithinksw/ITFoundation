/*
 *  ITLoginItem.h
 *  ITFoundation
 *
 *  Created by Kent Sutherland on Mon May 17 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import <CoreServices/CoreServices.h>

//These functions check for a match with just the lastPathComponent, so it will handle people moving the app
extern void ITSetApplicationLaunchOnLogin(NSString *path, BOOL flag);
extern BOOL ITDoesApplicationLaunchOnLogin(NSString *path);