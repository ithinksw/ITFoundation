/*
 *	ITFoundation
 *	ITThreadChild.h
 *
 *	Copyright (c) 2008 iThink Software
 *
 */

#import <Foundation/Foundation.h>

@protocol ITThreadChild <NSObject>
+ (void)runWithPorts:(NSArray *)portArray; // portArray[0] = receivePort, portArray[1] = sendPort. register an uninitialized object!
@end

@protocol ITThreadParent <NSObject>
- (id)objectByPerformingSelector:(SEL)selector onClass:(Class)class;
- (BOOL)registerThreadedChild:(id <ITThreadChild>)childObject; // receives an uninitialized (only alloc'd) child
@end

@interface ITThreadChild : NSObject <ITThreadChild> {

}

+ (void)runWithPorts:(NSArray *)portArray;

@end
