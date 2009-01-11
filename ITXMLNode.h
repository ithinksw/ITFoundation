/*
 *	ITFoundation
 *	ITXMLNode.h
 *
 *	Copyright (c) 2005 iThink Software
 *
 */

#import <Foundation/Foundation.h>

@interface ITXMLNode : NSObject {
	NSMutableArray *_children;
	NSString *_name;
}

//- (id)initWithSomeStuffHere;
//+ (ITXMLNode *)nodeWithSomeStuffHere;

//Accessors that I don't know the names of...
- (void)name;
- (NSData *)data;

- (NSArray *)children;
- (void)addChild:(ITXMLNode *)aChild;

@end