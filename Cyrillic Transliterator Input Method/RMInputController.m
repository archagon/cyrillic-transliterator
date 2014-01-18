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
        self.transliterator = [[RTTransliterator alloc] initWithLanguage:@"RU"];
        self.buffer = [[NSMutableString alloc] initWithString:@""];
    }
    return self;
}

-(BOOL) inputText:(NSString*)string client:(id)sender
{
    [self.buffer appendString:string];
    NSString* processedBuffer = [self processNewInput:self.buffer client:sender];
    
    if (processedBuffer)
    {
        self.processedBuffer = processedBuffer;
        
        return YES;
    }
    else
    {
        [self.buffer deleteCharactersInRange:NSMakeRange([self.buffer length] - [string length], [string length])];
        [self commitComposition:sender];
        
        processedBuffer = [self processNewInput:string client:sender];
        
        if (processedBuffer)
        {
            [self.buffer appendString:string];
            self.processedBuffer = processedBuffer;
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return NO;
}

-(BOOL) didCommandBySelector:(SEL)aSelector client:(id)sender
{
    NSLog(@"Translit command with selector: %@", NSStringFromSelector(aSelector));
    
    [self commitComposition:sender];
	
	return NO;
}

-(NSString*) processNewInput:(NSString*)string client:(id)sender
{
    BOOL haveNext = [self.transliterator hasNext:string];
    NSString* currentValue = [self.transliterator currentValueForString:string];
    BOOL stringHasViableFuture = haveNext || currentValue;
    NSArray* testNextValues = [self.transliterator nextPossibleLettersForString:string];
    
//    NSLog(@"Processing new input with %@, %d, %@, %d", string, haveNext, currentValue, stringHasViableFuture);
//    NSLog(@"Next values: %@", testNextValues);
    
    if (stringHasViableFuture)
    {
        if (currentValue)
        {
            [sender setMarkedText:currentValue selectionRange:NSMakeRange(0, [currentValue length]) replacementRange:NSMakeRange(NSNotFound, NSNotFound)];
        }
        else
        {
            [sender setMarkedText:string selectionRange:NSMakeRange(0, [string length]) replacementRange:NSMakeRange(NSNotFound, NSNotFound)];
        }
        
        if (currentValue)
        {
            return currentValue;
        }
        else
        {
            return self.buffer;
        }
    }
    else
    {
        return nil;
    }
}

-(void) commitComposition:(id)sender
{
    [sender insertText:self.processedBuffer replacementRange:NSMakeRange(NSNotFound, NSNotFound)];
    
    [self.buffer deleteCharactersInRange:NSMakeRange(0, [self.buffer length])];
    self.processedBuffer = nil;
}

@end
