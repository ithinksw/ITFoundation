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

#warning Need to add a constant data store containing all available component instances... could be lazy and build it on class +load.

@implementation ITOSAComponent

+ (ITOSAComponent *)appleScriptComponent
{
    return [[[ITOSAComponent alloc] initWithSubtype:kAppleScriptSubtype] autorelease];
}

+ (ITOSAComponent *)componentWithCarbonComponent:(Component)component
{
    return [[[ITOSAComponent alloc] initWithComponent:component] autorelease];
}

+ (NSArray *)availableComponents
{
    Component currentComponent = 0;
    ComponentDescription cd;
    NSMutableArray *components = [[NSMutableArray alloc] init];
    
    cd.componentType = kOSAComponentType;
    cd.componentSubType = 0;
    cd.componentManufacturer = 0;
    cd.componentFlags = 0;
    cd.componentFlagsMask = 0;
    while ((currentComponent = FindNextComponent(currentComponent, &cd)) != 0) {
        [components addObject:[ITOSAComponent componentWithCarbonComponent:currentComponent]];
    }
    return [NSArray arrayWithArray:[components autorelease]];
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
        
        AEDesc name;
        Ptr buffer;
        Size length;
        OSAScriptingComponentName(_componentInstance, &name);
        length = AEGetDescDataSize(&name);
        buffer = malloc(length);

        AEGetDescData(&name, buffer, length);
        AEDisposeDesc(&name);
        [information setObject:[NSString stringWithCString:buffer length:length] forKey:@"ITOSAComponentName"];
        free(buffer);
        buffer = NULL;
        
        //[information setObject:[[[NSString alloc] initWithBytes:componentName length:GetHandleSize(componentName) encoding:NSASCIIStringEncoding] autorelease] forKey:@"ITOSAComponentName"];
        [information setObject:[[[NSString alloc] initWithBytes:componentInfo length:GetHandleSize(componentInfo) encoding:NSASCIIStringEncoding] autorelease] forKey:@"ITOSAComponentInfo"];
        [information setObject:[NSNumber numberWithUnsignedLong:description.componentSubType] forKey:@"ITOSAComponentSubtype"];
        [information setObject:[NSNumber numberWithUnsignedLong:description.componentManufacturer] forKey:@"ITOSAComponentManufacturer"];
        _information = [information copy];
    }
    return self;
}

- (void)dealloc
{
    [_information release];
}

- (NSString *)description
{
    return [_information objectForKey:@"ITOSAComponentName"];
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
