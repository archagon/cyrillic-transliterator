//
//  RMAppDelegate.m
//  Cyrillic Transliterator Input Method
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
}

-(void) dealloc
{
    self.server = nil;
    self.connectionName = nil;
}

@end
