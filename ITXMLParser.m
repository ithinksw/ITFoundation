#import "ITXMLParser.h"
#import "ITXMLNode.h"

@implementation ITXMLParser

- (id)initWithContentsOfURL:(NSURL *)aURL {
	if ( (self = [super init]) ) {
		_source = [[NSString alloc] initWithContentsOfURL:aURL];
		_XMLPathSeparator = @"/";
	}
}

- (id)initWithContentsOfString:(NSString *)aString {
	if ( (self = [super init]) ) {
		_source = [aString copy];
		_XMLPathSeparator = @"/";
	}
}

- (void)dealloc {
	[_source release];
	[_XMLPathSeparator release];
}

- (NSString *)source {
	return _source;
}

- (NSDictionary *)declaration {
	return nil;
}

- (ITXMLNode *)nodeWithXMLPath {
	return nil;
}

- (void)setXMLPathSeparator:(NSString *)pathSeparator {
	[_XMLPathSeparator autorelease];
	_XMLPathSeparator = [pathSeparator copy];
}

- (NSString *)XMLPathSeparator {
	return _XMLPathSeparator;
}

@end