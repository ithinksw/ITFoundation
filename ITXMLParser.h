#import <Foundation/Foundation.h>
#import "ITXMLNode.h"

@interface ITXMLParser : NSObject
{
    NSString *_source;
    NSString *_XMLPathSeparator;
}

- (id)initWithContentsOfURL:(NSURL *)aURL;
- (id)initWithContentsOfString:(NSString *)aString;

- (NSString *)source;
- (NSDictionary *)declaration;

- (ITXMLNode *)rootNode;
- (ITXMLNode *)nodeWithXMLPath:(NSString *)path;

- (void)setXMLPathSeparator:(NSString *)pathSeparator;
- (NSString *)XMLPathSeparator;

@end