//
//  RBAppDelegate.h
//  RapidTranslit Monitor
//
//  Created by Alexei Baboulevitch on 1/18/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RBKeyTap.h"
#import "RBPreferencesController.h"

@interface RBAppDelegate : NSObject <NSApplicationDelegate>

-(IBAction) enableTapped:(NSMenuItem*)sender;
-(IBAction) preferencesTapped:(NSMenuItem*)sender;
-(IBAction) exitTapped:(NSMenuItem*)sender;

@property (assign) IBOutlet NSMenu* menu;
@property NSStatusItem* statusItem;
@property RBKeyTap* keyTap;
@property RBPreferencesController* preferences;

@end
