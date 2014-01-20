//
//  main.m
//  Translit Service
//
//  Created by Alexei Baboulevitch on 1/19/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RSAppDelegate.h"

int main(int argc, const char * argv[])
{
    // we have to do this instead of NSApplicationMain because we don't have a nib
    id<NSApplicationDelegate> delegate = [[RSAppDelegate alloc] init];
    [[NSApplication sharedApplication] setDelegate:delegate];
    [NSApp run];
    
    return 0; // TODO: is this correct? what does NSApplicationMain return?
}
