#import "ITCategory-NSObject.h"
#import <objc/objc-runtime.h>

@implementation NSObject (ITFoundationCategory)

+ (NSArray *)subclasses
{
	NSMutableArray *tempArray;
	NSArray *resultArray;
	Class *classes;
	Class superClass;
	Class *current;
	int count, newCount, index;
	tempArray = [[NSMutableArray allocWithZone:nil] initWithCapacity:12];
	resultArray = nil;
	if (tempArray) {
		classes = NULL;
		count = objc_getClassList(NULL, 0);
		if (count) {
			classes = malloc(sizeof(Class) * count);
			if (classes) {
				newCount = objc_getClassList(classes, count);
				while (count < newCount) {
					count = newCount;
					free(classes);
					classes = malloc(sizeof(Class) * count);
					if (classes) {
						newCount = objc_getClassList(classes, count);
					}
				}
				count = newCount;
			}
		}
		if (classes) {
			const Class thisClass = [self class];
			current = classes;
			for (index = 0; index < count; ++index) {
				superClass = class_getSuperclass((*current));
				if (superClass) {
					do {
						if (superClass == thisClass) {
							[tempArray addObject:*current];
							break;
						}
						superClass = class_getSuperclass(superClass);
					} while (superClass);
				}
				++current;
			}
			free(classes);
		}
		resultArray = [NSArray arrayWithArray:tempArray];
		[tempArray release];
	}
	return resultArray;
}

+ (NSArray *)directSubclasses
{
	NSMutableArray *tempArray;
	NSArray *resultArray;
	Class *classes;
	Class *current;
	int count, newCount, index;
	tempArray = [[NSMutableArray allocWithZone:nil] initWithCapacity:12];
	resultArray = nil;
	if (tempArray) {
		classes = NULL;
		count = objc_getClassList(NULL, 0);
		if (count) {
			classes = malloc(sizeof(Class) * count);
			if (classes) {
				newCount = objc_getClassList(classes, count);
				while (count < newCount) {
					count = newCount;
					free(classes);
					classes = malloc(sizeof(Class) * count);
					if (classes) {
						newCount = objc_getClassList(classes, count);
					}
				}
				count = newCount;
			}
		}
		if (classes) {
			const Class thisClass = [self class];
			current = classes;

			for (index = 0; index < count; ++index) {
				if (class_getSuperclass((*current)) == thisClass) {
					[tempArray addObject:*current];
				}
				++current;
			}
			free(classes);
		}
		resultArray = [NSArray arrayWithArray:tempArray];
		[tempArray release];
	}
	return resultArray;
}

@end