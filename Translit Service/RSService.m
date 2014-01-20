//
//  RSService.m
//  Cyrillic Transliterator
//
//  Created by Alexei Baboulevitch on 1/19/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RSService.h"

@implementation RSService

-(id) init
{
    self = [super init];
    if (self)
    {
        self.stream = [[RTTranslitStream alloc] initWithTransliterator:[[RTTransliterator alloc] initWithLanguage:@"RU"]];
    }
    return self;
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
    NSLog(@"Services pboard string: %@", pboardString);
    [self.stream addInput:pboardString];
    NSString* newString = [self.stream totalTransliteratedBuffer];
    NSLog(@"Services new string: %@", newString);
    
    // Write the encrypted string onto the pasteboard.
    [pboard clearContents];
    [pboard writeObjects:[NSArray arrayWithObject:newString]];
    
    // Cleanup.
    [self.stream resetBuffer];
}

@end
