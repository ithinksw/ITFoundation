#import "ITVirtualMemoryInfo.h"
#import <unistd.h>

@interface ITVirtualMemoryInfo (Private)
- (BOOL)refreshStats:(struct vm_statistics *)myStat;
@end

@implementation ITVirtualMemoryInfo

- (id)init
{
    if ( ( self = [super init] ) ) {
        if ([self refreshStats:&stat] == NO) {
            return nil;
        }
    }
    return self;
}

- (int)pageSize
{
    return getpagesize();
}

- (int)freePages
{
    [self refreshStats:&stat];
    return stat.free_count;
}

- (int)activePages
{
    [self refreshStats:&stat];
    return stat.active_count;
}

- (int)inactivePages
{
    [self refreshStats:&stat];
    return stat.inactive_count;
}

- (int)wiredPages
{
    [self refreshStats:&stat];
    return stat.wire_count;
}

- (int)faults
{
    [self refreshStats:&stat];
    return stat.faults;
}

- (int)copyOnWritePages
{
    [self refreshStats:&stat];
    return stat.cow_faults;
}

- (int)zeroFilledPages
{
    [self refreshStats:&stat];
    return stat.zero_fill_count;
}

- (int)reactivatedPages
{
    [self refreshStats:&stat];
    return stat.reactivations;
}

- (int)pageins
{
    [self refreshStats:&stat];
    return stat.pageins;
}

- (int)pageouts
{
    [self refreshStats:&stat];
    return stat.pageouts;
}

- (int)hits
{
    [self refreshStats:&stat];
    return stat.hits;
}

- (int)lookups
{
    [self refreshStats:&stat];
    return stat.lookups;
}

- (int)hitratePercentage
{
    [self refreshStats:&stat];
    if ( stat.lookups == 0 ) {
        return 0;
    } else {
        return ( ( stat.hits * 100 ) / stat.lookups );
    }
}

- (BOOL)refreshStats:(struct vm_statistics *)myStat
{
    bzero(myStat,sizeof(myStat));
    mach_port_t myHost = mach_host_self();
    int count = HOST_VM_INFO_COUNT;
    NSLog(@"%i",count);
    int returned = host_statistics(myHost, HOST_VM_INFO, myStat, &count);
    if ( returned != KERN_SUCCESS ) {
        NSLog(@"Failed to get Statistics in -refreshStats method of ITVirtualMemoryInfo");
        NSLog(@"%s",strerror(returned));
        return NO;
    } else {
        return YES;
    }
}

@end
