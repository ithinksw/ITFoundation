//
//  ITInetSocket.h
//  ITFoundation
//
//  Created by Alexander Strange on Tue Feb 11 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ITInetSocket : NSObject {

}
-(id)initWithFD:(int)fd delegate:(id)d;
@end
