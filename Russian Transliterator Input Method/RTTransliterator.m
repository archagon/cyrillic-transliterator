//
//  Transliterator.m
//  Russian Transliterator
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
        NSLog(@"Attempting to create transliterator");
        NSDictionary* plist = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:language ofType:@"plist"]];
        NSMutableDictionary* languageTree = [NSMutableDictionary dictionary];
        NSLog(@"Path is %@", [[NSBundle mainBundle] pathForResource:language ofType:@"plist"]);
        
        for (NSString* keyCombo in plist)
        {
            [self addSubstring:keyCombo withValue:plist[keyCombo] toTree:languageTree];
        }
        
        self.languageTree = languageTree;
    }
    return self;
}

-(NSString*) currentValueForString:(NSString*)substring
{
    NSDictionary* tree = self.languageTree;
    // TODO: NSNull
    id resultString = [[self nodeForSubstring:substring inTree:tree] objectAtIndex:0];
    return (resultString == [NSNull null] ? nil : resultString);
}

-(NSArray*) nextPossibleLettersForString:(NSString*)substring
{
    NSDictionary* tree = self.languageTree;
    NSArray* node = [self nodeForSubstring:substring inTree:tree];
    return [[node objectAtIndex:1] allKeys];
}

-(BOOL) hasNext:(NSString*)substring;
{
    return ([[self nextPossibleLettersForString:substring] count] > 0);
}

-(NSArray*) nodeForSubstring:(NSString*)substring inTree:(NSDictionary*)tree
{
    NSDictionary* currentTree = tree;
    
    for (NSUInteger i = 0; i < [substring length]; i++)
    {
        NSString* currentChar = [substring substringWithRange:NSMakeRange(i, 1)];
        NSArray* node = currentTree[currentChar];
        
        if (node == nil)
        {
            return nil;
        }
        
        if (i == [substring length] - 1)
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

-(void) addSubstring:(NSString*)substring withValue:(NSString*)value toTree:(NSMutableDictionary*)tree
{
    NSString* firstChar = [substring substringWithRange:NSMakeRange(0, 1)];
    
    if (!tree[firstChar])
    {
        NSMutableArray* node = [NSMutableArray array];
        [node addObject:[NSNull null]];
        [node addObject:[NSMutableDictionary dictionary]];
        tree[firstChar] = node;
    }
    
    if ([substring length] == 1)
    {
        [tree[firstChar] replaceObjectAtIndex:0 withObject:value];
    }
    else
    {
        [self addSubstring:[substring substringFromIndex:1] withValue:value toTree:[tree[firstChar] objectAtIndex:1]];
    }
}

-(void) debugPrintTreeDFS:(NSArray*)node
{
    if (!node) return;
    
    NSLog(@"Translit node value: %@", node[0]);

    for (NSArray* key in node[1])
    {
        [self debugPrintTreeDFS:node[1][key]];
    }
}

@end
