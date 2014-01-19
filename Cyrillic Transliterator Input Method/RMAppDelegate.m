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
    NSString* connectionName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"InputMethodConnectionName"];
    self.server = [[IMKServer alloc] initWithName:connectionName bundleIdentifier:[[NSBundle mainBundle] bundleIdentifier]];
}

@end
