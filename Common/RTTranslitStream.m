//
//  RTTranslitStream.m
//  Cyrillic Transliterator
//
//  Created by Alexei Baboulevitch on 1/17/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RTTranslitStream.h"

// TODO: would this be better off as an NSStream?

@interface RTTranslitStream ()

@property (nonatomic) RTTransliterator* transliterator;
@property (nonatomic, readwrite) NSMutableString* completeBuffer;
@property (nonatomic, readwrite) NSMutableString* completeTransliteratedBuffer;
@property (nonatomic, readwrite) NSMutableString* incompleteBuffer;
@property (nonatomic, readwrite) NSMutableString* incompleteTransliteratedBuffer;

@end

@implementation RTTranslitStream

-(id) initWithTransliterator:(RTTransliterator*)transliterator
{
    self = [super init];
    if (self)
    {
        self.transliterator = transliterator;
        self.completeBuffer = [[NSMutableString alloc] initWithCapacity:self.transliterator.longestKeyLength];
        self.completeTransliteratedBuffer = [[NSMutableString alloc] initWithCapacity:self.transliterator.longestKeyLength];
        self.incompleteBuffer = [[NSMutableString alloc] initWithCapacity:self.transliterator.longestKeyLength];
        self.incompleteTransliteratedBuffer = [[NSMutableString alloc] initWithCapacity:self.transliterator.longestKeyLength];
    }
    return self;
}

-(void) resetBuffer
{
    [self.completeBuffer deleteCharactersInRange:NSMakeRange(0, [self.completeBuffer length])];
    [self.completeTransliteratedBuffer deleteCharactersInRange:NSMakeRange(0, [self.completeTransliteratedBuffer length])];
    [self.incompleteBuffer deleteCharactersInRange:NSMakeRange(0, [self.incompleteBuffer length])];
    [self.incompleteTransliteratedBuffer deleteCharactersInRange:NSMakeRange(0, [self.incompleteTransliteratedBuffer length])];
}

-(void) clearCompleteBuffer
{
    [self.completeBuffer deleteCharactersInRange:NSMakeRange(0, [self.completeBuffer length])];
    [self.completeTransliteratedBuffer deleteCharactersInRange:NSMakeRange(0, [self.completeTransliteratedBuffer length])];
}

-(NSString*) totalBuffer
{
    return [self.completeBuffer stringByAppendingString:self.incompleteBuffer];
}

-(NSString*) totalTransliteratedBuffer
{
    return [self.completeTransliteratedBuffer stringByAppendingString:self.incompleteTransliteratedBuffer];
}

-(void) addInput:(NSString*)string
{
    // easier to clear for now, should revisit if performance issues
    [self.incompleteTransliteratedBuffer deleteCharactersInRange:NSMakeRange(0, [self.incompleteTransliteratedBuffer length])];
    
    [self.incompleteBuffer appendString:string];
    
    BOOL foundIncompleteSubstring = NO;
    NSInteger startingIndexOfFirstIncompleteSubstring = 0;
    NSUInteger i = 0;
    
    while (i < [self.incompleteBuffer length])
    {
        // Test the substring starting at the index 'i'. While there are still possible matches with more added characters,
        // keep adding to it, character by character. Stop either when we reach the end of the buffer (at which point
        // we know we have to leave it in the incomplete pile) or when we run out of future matches (at which point
        // we can move it to the complete pile).
        
        // TODO: might not play nice with Unicode precomposed characters; would need to use rangeOfComposedCharacterSequencesForRange
        
        // the initial "value" is simply the untransliterated character, in case we don't find any matches
        NSUInteger lengthOfCurrentSubstring = 1;
        NSUInteger lengthOfLastSubstringWithValue = 1;
        NSString* lastSubstringWithValue = [self.incompleteBuffer substringWithRange:NSMakeRange(i, lengthOfCurrentSubstring)];
        NSString* lastValue = lastSubstringWithValue;
        
        BOOL hitEndOfBuffer = NO;
        
        while (true)
        {
            // this will definitely get hit at some point; ergo, we won't get stuck in an infinite loop
            if (i + lengthOfCurrentSubstring > [self.incompleteBuffer length])
            {
                hitEndOfBuffer = YES;
                break;
            }
            
            NSString* substring = [self.incompleteBuffer substringWithRange:NSMakeRange(i, lengthOfCurrentSubstring)];
            NSString* value = [self.transliterator currentValueForString:substring];
            BOOL hasNext = [self.transliterator hasNext:substring];
            
            if (value)
            {
                lengthOfLastSubstringWithValue = lengthOfCurrentSubstring;
                lastSubstringWithValue = substring;
                lastValue = value;
            }
            
            if (!hasNext)
            {
                break;
            }
            
            lengthOfCurrentSubstring++;
        }
        
        if (!foundIncompleteSubstring)
        {
            startingIndexOfFirstIncompleteSubstring = i;
        }
        
        if (!hitEndOfBuffer && !foundIncompleteSubstring)
        {
            [self.completeBuffer appendString:lastSubstringWithValue];
            [self.completeTransliteratedBuffer appendString:lastValue];
        }
        else
        {
            foundIncompleteSubstring = YES;
            
            // no need to add anything to incompleteBuffer, all the characters are already there
            [self.incompleteTransliteratedBuffer appendString:lastValue];
        }
        
        i = (i + lengthOfLastSubstringWithValue);
    }

    if (foundIncompleteSubstring)
    {
        [self.incompleteBuffer deleteCharactersInRange:NSMakeRange(0, startingIndexOfFirstIncompleteSubstring)];
    }
    else
    {
        [self.incompleteBuffer deleteCharactersInRange:NSMakeRange(0, [self.incompleteBuffer length])];
    }
}

@end
    