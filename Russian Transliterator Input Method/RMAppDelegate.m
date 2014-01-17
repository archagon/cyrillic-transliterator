//
//  RMAppDelegate.m
//  Russian Transliterator Input Method
//
//  Created by Alexei Baboulevitch on 1/15/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RMAppDelegate.h"
#import "RMInputController.h"

@implementation RMAppDelegate

-(void) applicationDidFinishLaunching:(NSNotification*)aNotification
{
    self.connectionName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"InputMethodConnectionName"];
    self.server = [[IMKServer alloc] initWithName:self.connectionName bundleIdentifier:[[NSBundle mainBundle] bundleIdentifier]];
    
//    RMInputController* testInputController = [[RMInputController alloc] init];
//    [testInputController inputText:@"s" key:0 modifiers:0 client:nil];
//    [testInputController inputText:@"h" key:0 modifiers:0 client:nil];
//    [testInputController inputText:@"h" key:0 modifiers:0 client:nil];
//    [testInputController inputText:@"h" key:0 modifiers:0 client:nil];
//    [testInputController inputText:@"h" key:0 modifiers:0 client:nil];
}

-(void) dealloc
{
    self.server = nil;
    self.connectionName = nil;
}

@end
