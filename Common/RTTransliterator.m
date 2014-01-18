//
//  Transliterator.m
//  Cyrillic Transliterator
//
//  Created by Alexei Baboulevitch on 1/16/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RTTransliterator.h"

// TODO: currently uses makeshift NSDictionary tree; make into separate class to make maintenance easier

@implementation RTTransliterator

-(id) initWithLanguage:(NSString*)language
{
    self = [super init];
    if (self)
    {
        NSDictionary* plist = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:language ofType:@"plist"]];
        NSMutableDictionary* languageTree = [NSMutableDictionary dictionary];
        
        for (NSString* keyCombo in plist)
        {
            [self addString:keyCombo withValue:plist[keyCombo] toTree:languageTree];
        }
        
        self.languageTree = languageTree;
    }
    return self;
}

-(NSString*) currentValueForString:(NSString*)string
{
    NSDictionary* tree = self.languageTree;
    id resultString = [[self nodeForString:string inTree:tree] objectAtIndex:0];
    return (resultString == [NSNull null] ? nil : resultString);
}

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
