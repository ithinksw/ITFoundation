//
//  ShowcaseController.m
//  ITFoundation
//
//  Created by Alexander Strange on Fri Feb 14 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "ShowcaseController.h"
#import "ITInetSocket.h"


@implementation ShowcaseController
- (void)awakeFromNib
{
    
    ITInetSocket *sock = [[ITInetSocket alloc] initWithDelegate:self];
    NSLog(@"rawr?");
    [sock connectToHost:@"66.111.58.80" onPort:4336];
}

- (void) finishedConnecting:(in ITInetSocket *)sender {
    NSLog(@"Done connectin'");
    NSData *d = [NSData dataWithBytesNoCopy:"M00f!" length:5];
    [sender->writePipe writeData:d];
}
- (void) errorOccured:(ITInetSocketError)err during:(ITInetSocketState)state onSocket:(in ITInetSocket*)sender {NSLog(@"wtf");[sender retryConnection];}
- (void) dataReceived:(in ITInetSocket *)sender
{
    ITByteStream *p = sender->readPipe;
    NSData *d = [p readAllData];
    NSLog(@"%@",d);
}

@end
