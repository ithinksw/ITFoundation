//
//  ShowcaseController.m
//  ITFoundation
//
//  Created by Alexander Strange on Fri Feb 14 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "ShowcaseController.h"
#import "ITInetSocket.h"

ITInetSocket *sock;

@implementation ShowcaseController
- (void)awakeFromNib
{
    sock = [[ITInetSocket alloc] initWithDelegate:self];
    NSLog(@"rawr?");
    [sock connectToHost:@"irc.freenode.net" onPort:6667];
}

- (void) finishedConnecting:(ITInetSocket *)sender {

}

- (void) errorOccured:(ITInetSocketError)err during:(ITInetSocketState)state onSocket:(in ITInetSocket*)sender {NSLog(@"wtf");[sender retryConnection];}
- (void) dataReceived:(ITInetSocket *)sender
{
}

- (void) newDataAdded:(ITByteStream*)sender {
    static int firstTime = YES;
    NSString *ircini = @"USER m0nk3ys . . :Not Telling\r\nNICK ITFTest\r\n", *irc2 = @"JOIN #iThink\r\nPRIVMSG #iThink :w00t\r\nQUIT :!\r\n";
    NSLog(@"Writing something");
    NSData *d = [NSData dataWithBytes:[firstTime?ircini:irc2 cString] length:[firstTime?ircini:irc2 length]];
    [sock->writePipe writeData:d];
    NSLog(@"Reading something");
    firstTime = NO;
}
@end
