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
    [sock connectToHost:@"irc.freenode.net" onPort:6667];
}

- (void) finishedConnecting:(in ITInetSocket *)sender {
    NSString *ircini = @"NICK ITFTest\r\nUSER m0nk3ys . . :Not Tellin'\r\nJOIN #iThink\r\nPRIVMSG #iThink :w00t\r\nQUIT :!\r\n";
    NSLog(@"Done connectin'");
    NSData *d = [NSData dataWithBytes:[ircini cString] length:[ircini length]];
    [sender->writePipe writeData:d];
    NSLog(@"%@",sender->writePipe->data);
}
- (void) errorOccured:(ITInetSocketError)err during:(ITInetSocketState)state onSocket:(in ITInetSocket*)sender {NSLog(@"wtf");[sender retryConnection];}
- (void) dataReceived:(in ITInetSocket *)sender
{
    ITByteStream *p = sender->readPipe;
    NSData *d = [p readAllData];
    NSLog(@"%@",d);
}

@end
