//
//  RBAppDelegate.h
//  RapidTranslit Monitor
//
//  Created by Alexei Baboulevitch on 1/18/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RBKeyTap.h"

@interface RBAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSMenu* menu;
@property NSStatusItem* statusItem;
@property RBKeyTap* keyTap;

@end
