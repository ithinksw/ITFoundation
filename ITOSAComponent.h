/*
 *	ITFoundation
 *      ITOSAComponent
 *          A Cocoa wrapper for scripting components.
 *
 *	Original Author	: Kent Sutherland <ksutherland@ithinksw.com>
 *      Responsibility : Kent Sutherland <ksutherland@ithinksw.com>
 *      Responsibility : Joseph Spiros <joseph.spiros@ithinksw.com>
 *
 *	Copyright (c) 2002 - 2004 iThink Software.
 *	All Rights Reserved
 *
 */

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

@interface ITOSAComponent : NSObject {
    Component _component;
    ComponentInstance _componentInstance;
    NSDictionary *_information;
}
+ (ITOSAComponent *)AppleScriptComponent;
+ (ITOSAComponent *)componentWithCarbonComponent:(Component)component;
+ (NSArray *)availableComponents;

- (id)initWithSubtype:(unsigned long)subtype;
- (id)initWithComponent:(Component)component;

- (Component)component;
- (ComponentInstance)componentInstance;
- (NSDictionary *)information;

@end
