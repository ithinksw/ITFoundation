/*
 *  ITLoginItem.m
 *  ITFoundation
 *
 *  Created by Kent Sutherland on Mon May 17 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */

#import "ITLoginItem.h"
#import "ITDebug.h"

BOOL ITSetLaunchApplicationOnLogin(NSString *path, BOOL flag)
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *loginwindow;
    NSMutableArray *loginarray;
    FSRef fileRef;
    AliasHandle alias;
    NSData *aliasData;
    
    ITDebugLog(@"Set if MenuPrefs launches at login to %i.", flag);
    [df synchronize];
    loginwindow = [[df persistentDomainForName:@"loginwindow"] mutableCopy];
    loginarray = [loginwindow objectForKey:@"AutoLaunchedApplicationDictionary"];
    
    //Create the alias data
    FSPathMakeRef([path UTF8String], &fileRef, NULL);
    FSNewAlias(NULL, &fileRef, &alias);
    aliasData = [NSData dataWithBytes:&alias length:sizeof(alias)];
    
    if (flag) {
        NSDictionary *itemDict = [NSDictionary dictionaryWithObjectsAndKeys:
        [[NSBundle mainBundle] bundlePath], @"Path",
        [NSNumber numberWithInt:0], @"Hide",
        aliasData, @"AliasData", nil, nil];
        [loginarray addObject:itemDict];
    } else {
        int i;
        for (i = 0; i < [loginarray count]; i++) {
            NSDictionary *tempDict = [loginarray objectAtIndex:i];
            if ([[[tempDict objectForKey:@"Path"] lastPathComponent] isEqualToString:[[[NSBundle mainBundle] bundlePath] lastPathComponent]]) {
                [loginarray removeObjectAtIndex:i];
                break;
            }
        }
    }
    [df setPersistentDomain:loginwindow forName:@"loginwindow"];
    [df synchronize];
    [loginwindow release];
    return YES;
}