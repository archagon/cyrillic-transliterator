//
//  NSRobustXMLElement.m
//  Cyrillic Transliterator
//
//  Created by Alexei Baboulevitch on 1/20/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "NSRobustXMLElement.h"

@implementation NSRobustXMLElement

-(id)initWithName:(NSString *)name URI:(NSString *)URI
{
    return [super initWithName:name URI:URI];
}

-(void)addAttribute:(NSXMLNode *)attribute
{
    return [super addAttribute:attribute];
}

-(void)removeAttributeForName:(NSString *)name
{
    return [super removeAttributeForName:name];
}

-(void)setAttributes:(NSArray *)attributes
{
    return [super setAttributes:attributes];
}

-(NSXMLNode *)attributeForLocalName:(NSString *)localName URI:(NSString *)URI
{
    return [super attributeForLocalName:localName URI:URI];
}

-(NSArray *)attributes
{
    return [super attributes];
}

-(void)addNamespace:(NSXMLNode *)aNamespace
{
    return [super addNamespace:aNamespace];
}

-(void)removeNamespaceForPrefix:(NSString *)name
{
    return [super removeNamespaceForPrefix:name];
}

-(void)setNamespaces:(NSArray *)namespaces
{
    return [super setNamespaces:namespaces];
}

-(NSArray *)namespaces
{
    return [super namespaces];
}

-(void)insertChild:(NSXMLNode *)child atIndex:(NSUInteger)index
{
    return [super insertChild:child atIndex:index];
}

-(void)removeChildAtIndex:(NSUInteger)index
{
    return [super removeChildAtIndex:index];
}

-(void)setChildren:(NSArray *)children
{
    return [super setChildren:children];
}

@end
