#import "ITCategory-NSArray.h"


@implementation NSArray (ITCategory)

- (NSArray *)objectsForKey:(NSString *)key
{
    NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:[self count]] autorelease];
    NSEnumerator *enumerator = [self objectEnumerator];
    id anItem;
    
    while ( (anItem = [enumerator nextObject]) ) {
    
        id itemObject = [anItem objectForKey:key];
        
        if ( itemObject ) {
            [array addObject:itemObject];
        } else {
            [array addObject:[NSNull null]];
        }
    }
    
    return array;
}

- (BOOL)containsString:(NSString *)string
{
    NSEnumerator *enumerator = [self objectEnumerator];
    id anItem;
    BOOL result = NO;
    
    while ( (anItem = [enumerator nextObject]) ) {
        
        if ( ([[anItem class] isEqual:[NSString class]]) && [anItem isEqualToString:string] ) {
            result = YES;
        }
    }

    return result;
}

@end
