//
//  RMInputController.m
//  Cyrillic Transliterator Input Method
//
//  Created by Alexei Baboulevitch on 1/15/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RMInputController.h"

@implementation RMInputController

-(id) initWithServer:(IMKServer*)server delegate:(id)delegate client:(id)inputClient
{
    self = [super initWithServer:server delegate:delegate client:inputClient];
    
    if (self)
    {
        self.stream = [[RTTranslitStream alloc] initWithTransliterator:[[RTTransliterator alloc] initWithLanguage:@"RU"]];
    }
    
    return self;
}

-(BOOL) inputText:(NSString*)string client:(id)sender
{
    [self.stream addInput:string];
    
    if ([[self.stream incompleteBuffer] length] != 0 || [[self.stream completeBuffer] length] != 0)
    {
        [self commit:NO sender:sender];
        
        NSString* incompleteBuffer = [self.stream incompleteBuffer];
        
        if (incompleteBuffer)
        {
            [sender setMarkedText:[self.stream incompleteTransliteratedBuffer] selectionRange:NSMakeRange(0, [incompleteBuffer length]) replacementRange:NSMakeRange(NSNotFound, NSNotFound)];
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL) didCommandBySelector:(SEL)aSelector client:(id)sender
{
    NSLog(@"Translit command with selector: %@", NSStringFromSelector(aSelector));
    
    [self commit:YES sender:sender];
	
	return NO;
}

-(void) commit:(BOOL)total sender:(id)sender
{
    if (!total)
    {
        NSString* completeBuffer = [self.stream completeBuffer];
        
        if (completeBuffer)
        {
            [sender insertText:[self.stream completeTransliteratedBuffer] replacementRange:NSMakeRange(NSNotFound, NSNotFound)];
            [self.stream clearCompleteBuffer];
        }
    }
    else
    {
        NSString* totalBuffer = [self.stream totalBuffer];
        
        if (totalBuffer)
        {
            [sender insertText:[self.stream totalTransliteratedBuffer] replacementRange:NSMakeRange(NSNotFound, NSNotFound)];
            [self.stream resetBuffer];
        }
    }
}

-(void) commitComposition:(id)sender
{
    [self commit:YES sender:sender];
}

@end
