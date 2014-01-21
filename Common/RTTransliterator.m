//
//  Transliterator.m
//  Cyrillic Transliterator
//
//  Created by Alexei Baboulevitch on 1/16/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RTTransliterator.h"

// TODO: currently uses makeshift NSDictionary trie; make into separate class to make maintenance easier -- trie, radix?

@interface RTTransliterator ()

@property (nonatomic, readwrite) NSDictionary* languageTree;
@property (nonatomic, readwrite) NSUInteger longestKeyLength;

@end

@implementation RTTransliterator

-(id) initWithLanguage:(NSString*)language
{
    NSString* pathForJson = [[NSBundle mainBundle] pathForResource:language ofType:@"translit"];
    
    if (pathForJson)
    {
        return [self initWithJsonPath:pathForJson];
    }
    else
    {
        NSString* pathForPlist = [[NSBundle mainBundle] pathForResource:language ofType:@"plist"];
        return [self initWithPlistPath:pathForPlist];
    }
}

-(id) initWithPlistPath:(NSString*)path
{
    NSDictionary* plist = [NSDictionary dictionaryWithContentsOfFile:path];
    return [self initWithDictionary:plist];
}

-(id) initWithJsonPath:(NSString*)path
{
    NSData* jsonData = [NSData dataWithContentsOfFile:path];
    
    NSError* error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    return [self initWithDictionary:object];
    
    // TODO: check error, check if object is actually dict
}

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        NSMutableDictionary* languageTree = [NSMutableDictionary dictionary];
        
        for (NSString* keyCombo in dictionary)
        {
            [self addString:keyCombo withValue:dictionary[keyCombo] toTree:languageTree];
            self.longestKeyLength = MAX(self.longestKeyLength, [keyCombo length]);
        }
        
        self.languageTree = languageTree;
    }
    return self;
}

-(NSArray*) startingLetters
{
    return [self.languageTree allKeys];
}

-(NSString*) currentValueForString:(NSString*)string
{
    NSDictionary* tree = self.languageTree;
    id resultString = [[self nodeForString:string inTree:tree] objectAtIndex:0];
    return (resultString == [NSNull null] ? nil : resultString);
}

// TODO: accept nil
-(NSArray*) nextPossibleLettersForString:(NSString*)string
{
    NSDictionary* tree = self.languageTree;
    NSArray* node = [self nodeForString:string inTree:tree];
    return [[node objectAtIndex:1] allKeys];
}

-(BOOL) hasNext:(NSString*)string;
{
    return ([[self nextPossibleLettersForString:string] count] > 0);
}

// TODO: accept nil
-(NSArray*) nodeForString:(NSString*)string inTree:(NSDictionary*)tree
{
    NSDictionary* currentTree = tree;
    
    for (NSUInteger i = 0; i < [string length]; i++)
    {
        NSString* currentChar = [string substringWithRange:NSMakeRange(i, 1)];
        NSArray* node = currentTree[currentChar];
        
        if (node == nil)
        {
            return nil;
        }
        
        if (i == [string length] - 1)
        {
            return node;
        }
        else
        {
            NSDictionary* newTree = [node objectAtIndex:1];
            currentTree = newTree;
        }
    }
    
    return nil;
}

-(void) addString:(NSString*)string withValue:(NSString*)value toTree:(NSMutableDictionary*)tree
{
    NSString* firstChar = [string substringWithRange:NSMakeRange(0, 1)];
    
    if (!tree[firstChar])
    {
        NSMutableArray* node = [NSMutableArray array];
        [node addObject:[NSNull null]];
        [node addObject:[NSMutableDictionary dictionary]];
        tree[firstChar] = node;
    }
    
    if ([string length] == 1)
    {
        [tree[firstChar] replaceObjectAtIndex:0 withObject:value];
    }
    else
    {
        [self addString:[string substringFromIndex:1] withValue:value toTree:[tree[firstChar] objectAtIndex:1]];
    }
}

@end
