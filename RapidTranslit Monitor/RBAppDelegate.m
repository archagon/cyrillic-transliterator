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
    [self.statusItem setImage:[NSImage imageNamed:@"icon"]];
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setMenu:self.menu];
    
    self.keyTap = [[RBKeyTap alloc] init];
    [self.keyTap start];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kTranslitEnabled"])
    {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kTranslitEnabled"] == NSOnState)
        {
            [self.keyTap start];
        }
        else
        {
            [self.keyTap stop];
        }
    }
    else
    {
        [self.keyTap start];
    }
}

-(BOOL) validateMenuItem:(NSMenuItem*)menuItem
{
    if ([menuItem action] == @selector(enableTapped:))
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kTranslitEnabled"])
        {
            [menuItem setState:[[NSUserDefaults standardUserDefaults] integerForKey:@"kTranslitEnabled"]];
        }
        else
        {
            [menuItem setState:NSOnState];
        }
    }
    
    return YES;
}

-(IBAction) enableTapped:(NSMenuItem*)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:([sender state] == NSOnState ? NSOffState : NSOnState) forKey:@"kTranslitEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [sender setState:([sender state] == NSOnState ? NSOffState : NSOnState)];
    
    if ([sender state] == NSOnState)
    {
        [self.keyTap start];
    }
    else
    {
        [self.keyTap stop];
    }
}

-(IBAction) preferencesTapped:(NSMenuItem*)sender
{
    self.preferences = [[RBPreferencesController alloc] initWithWindowNibName:@"Preferences"];
    [self.preferences showWindow:nil];
}

-(IBAction) exitTapped:(NSMenuItem*)sender
{
    [NSApp terminate:nil];
}

@end
