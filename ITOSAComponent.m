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

#import "ITOSAComponent.h"

@implementation ITOSAComponent

+ (NSArray *)availableComponents
{
    Component currentComponent = 0;
    ComponentDescription cd;
    
    cd.componentType = kOSAComponentType;
    cd.componentSubType = 0;
    cd.componentManufacturer = 0;
    cd.componentFlags = 0;
    cd.componentFlagsMask = 0;
    
    while ((currentComponent = FindNextComponent(0, &cd)) != 0) {
    }
    return [NSArray array];
}

- (id)initWithSubtype:(unsigned long)subtype
{
    ComponentDescription cd;
    cd.componentType = kOSAComponentType;
    cd.componentSubType = subtype;
    cd.componentManufacturer = 0;
    cd.componentFlags = 0;
    cd.componentFlagsMask = 0;
    Component temp = FindNextComponent(0, &cd);
    if ( (self = [self initWithComponent:temp]) ) {
    }
    return self;
}

- (id)initWithComponent:(Component)component;
{
    if ( (self = [super init]) ) {
        Handle componentName = NewHandle(0);
        Handle componentInfo = NewHandle(0);
        ComponentDescription description;
        NSMutableDictionary *information;
        
        _component = component;
        _componentInstance = OpenComponent(component);
        
        if (GetComponentInfo(component, &description, componentName, componentInfo, nil) != 0) {
            NSLog(@"FATAL ERROR!");
            return nil;
        }
        
        information = [[NSMutableDictionary alloc] init];
        [information setObject:[[[NSString alloc] initWithBytes:componentName length:GetHandleSize(componentName) encoding:NSASCIIStringEncoding] autorelease] forKey:@"ITComponentName"];
        [information setObject:[[[NSString alloc] initWithBytes:componentInfo length:GetHandleSize(componentInfo) encoding:NSASCIIStringEncoding] autorelease] forKey:@"ITComponentInfo"];
        [information setObject:[NSNumber numberWithUnsignedLong:description.componentSubType] forKey:@"ITComponentSubtype"];
        [information setObject:[NSNumber numberWithUnsignedLong:description.componentManufacturer] forKey:@"ITComponentManufacturer"];
        
    }
    return self;
}

- (void)dealloc
{
    [_information release];
}

- (Component)component
{
    return _component;
}

- (ComponentInstance)componentInstance
{
    return _componentInstance;
}

- (NSDictionary *)information
{
    return _information;
}

@end
