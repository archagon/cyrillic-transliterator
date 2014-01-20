//
//  RSAppDelegate.m
//  Translit Service
//
//  Created by Alexei Baboulevitch on 1/19/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

// http://stackoverflow.com/questions/3859747/how-do-i-automatically-activate-an-item-in-the-os-x-services-menu

#import "RSAppDelegate.h"

@implementation RSAppDelegate

-(void) applicationDidFinishLaunching:(NSNotification*)aNotification
{
    self.stream = [[RTTranslitStream alloc] initWithTransliterator:[[RTTransliterator alloc] initWithLanguage:@"RU"]];
    [NSApp setServicesProvider:self];
}

-(void) translit:(NSPasteboard*)pboard userData:(NSString*)userData error:(NSString**)error
{
    // Test for strings on the pasteboard.
    NSArray* classes = [NSArray arrayWithObject:[NSString class]];
    NSDictionary* options = [NSDictionary dictionary];
    
    if (![pboard canReadObjectForClasses:classes options:options])
    {
        *error = NSLocalizedString(@"Error: couldn't encrypt text.",
                                   @"pboard couldn't give string.");
        return;
    }
    
    // Get and encrypt the string.
    NSString* pboardString = [pboard stringForType:NSPasteboardTypeString];
    [self.stream addInput:pboardString];
    NSString* newString = [self.stream totalTransliteratedBuffer];
    
    // Write the encrypted string onto the pasteboard.
    [pboard clearContents];
    [pboard writeObjects:[NSArray arrayWithObject:newString]];
    
    // Cleanup.
    [self.stream resetBuffer];
}

@end
