/*
 *	ITFoundation
 *	ITVirtualMemoryInfo.h
 *
 *	Class that provides utilities for getting information on Mac OS X's mach
 *		kernel's virtual memory settings and status.
 *
 *	Copyright (c) 2005 by iThink Software.
 *	All Rights Reserved.
 *
 *	$Id$
 *
 */

#import <Foundation/Foundation.h>
#import <mach/mach.h>

/* For Mac OS X the default page size is 4096 (4K) */
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