//
//  ShowcaseController.h
//  ITFoundation
//
//  Created by Alexander Strange on Fri Feb 14 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ITFoundation/ITInetSocket.h>
#import <ITFoundation/ITInetServerSocket.h>

@interface ShowcaseController : NSObject <ITInetSocketDelegate,ITInetServerSocketOwner> {
    ITInetServerSocket *server;
}

@end
