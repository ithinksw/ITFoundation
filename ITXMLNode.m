#import "ITXMLNode.h"

@implementation ITXMLNode

- (NSArray *)children {
	return [NSArray arrayWithArray:_children];
}

- (void)addChild:(ITXMLNode *)aChild {
	[_children addObject:aChild];
}

@end