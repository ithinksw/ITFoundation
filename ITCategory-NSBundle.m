#import "ITCategory-NSBundle.h"

@implementation NSBundle (ITCategory)

+ (NSBundle *)bundleForFrameworkWithIdentifier:(NSString *)frameworkIdentifier {
	NSMutableArray *frameworksPaths = [NSMutableArray array];
	NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSAllDomainsMask,YES);
	NSEnumerator *libraryEnumerator = [libraryPaths objectEnumerator];
	NSString *libraryPath;
	
	[frameworksPaths addObject:[[self mainBundle] privateFrameworksPath]];
	[frameworksPaths addObject:[[self mainBundle] sharedFrameworksPath]];
	
	while (libraryPath = [libraryEnumerator nextObject]) {
		[frameworksPaths addObject:[libraryPath stringByAppendingPathComponent:@"Frameworks"]];
		[frameworksPaths addObject:[libraryPath stringByAppendingPathComponent:@"PrivateFrameworks"]];
	}
	
	NSEnumerator *frameworksEnumerator = [frameworksPaths objectEnumerator];
	NSString *frameworksPath;
	
	while (frameworksPath = [frameworksEnumerator nextObject]) {
		NSArray *frameworkPaths = [NSBundle pathsForResourcesOfType:@"framework" inDirectory:frameworksPath];
		NSEnumerator *frameworkEnumerator = [frameworkPaths objectEnumerator];
		NSString *frameworkPath;
		
		while (frameworkPath = [frameworkEnumerator nextObject]) {
			NSBundle *frameworkBundle = [NSBundle bundleWithPath:frameworkPath];
			if (frameworkBundle && [[frameworkBundle bundleIdentifier] isEqualToString:frameworkIdentifier]) {
				return frameworkBundle;
			}
		}
	}
	
	return nil;
}

@end
