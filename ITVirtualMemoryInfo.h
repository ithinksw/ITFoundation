/*
 *	ITFoundation
 *	ITVirtualMemoryInfo
 *
 *	Class that provides utilities for getting information
 *	on Mac OS X's mach kernel's Virtual Memory settings
 *	and status
 *
 *	Original Author	: Joseph Spiros <joseph.spiros@ithinksw.com>
 *	Responsibility	: Joseph Spiros <joseph.spiros@ithinksw.com>
 *			: Matt Judy <matt.judy@ithinksw.com>
 *
 *	Copyright (c) 2002 iThink Software.
 *	All Rights Reserved
 *
 */

#import <Foundation/Foundation.h>
#import <mach/mach.h>

/* For this platform, as of this Mach version,
 * the default page size is 4096, or 4k */
#define DEFAULT_PAGE_SIZE 4096


@interface ITVirtualMemoryInfo : NSObject {
    vm_statistics_data_t stat;
}

- (id)init;
- (int)pageSize;
- (int)freePages;
- (int)activePages;
- (int)inactivePages;
- (int)wiredPages;
- (int)faults;
- (int)copyOnWritePages;
- (int)zeroFilledPages;
- (int)reactivatedPages;
- (int)pageins;
- (int)pageouts;
- (int)hits;
- (int)lookups;
- (int)hitratePercentage;

@end
