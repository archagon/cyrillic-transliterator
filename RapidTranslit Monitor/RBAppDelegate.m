//
//  RBAppDelegate.m
//  RapidTranslit Monitor
//
//  Created by Alexei Baboulevitch on 1/18/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RBAppDelegate.h"

@implementation RBAppDelegate

-(void) applicationDidFinishLaunching:(NSNotification*)aNotification
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    [self.statusItem setImage:[NSImage imageNamed:@"icon.tiff"]];
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setMenu:self.menu];
}

@end
