//
//  ITServiceBrowserDelegate.h
//  ITFoundation
//
//  Created by Alexander Strange on Sat Mar 15 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSNetServices.h>

@interface ITServiceBrowserDelegate : NSObject {
    id delegate;
}
-(id) initWithDelegate:(id)delegate;
@end
