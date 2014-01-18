//
//  main.m
//  Cyrillic Transliterator Input Method
//
//  Created by Alexei Baboulevitch on 1/15/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RMAppDelegate.h"

int main(int argc, const char * argv[])
{
    // we have to do this instead of NSApplicationMain because we don't have a nib
    id<NSApplicationDelegate> delegate = [[RMAppDelegate alloc] init];
    [[NSApplication sharedApplication] setDelegate:delegate];
    [NSApp run];
    
    return 0; // TODO: is this correct? what does NSApplicationMain return?
}
