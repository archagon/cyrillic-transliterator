//
//  NSRobustXMLNode.m
//  Cyrillic Transliterator
//
//  Created by Alexei Baboulevitch on 1/20/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "NSRobustXMLNode.h"

@implementation NSRobustXMLNode

-(id)initWithKind:(NSXMLNodeKind)kind options:(NSUInteger)options
{
    return [super initWithKind:kind options:options];
}

-(NSXMLNodeKind)kind
{
    return [super kind];
}

-(NSString *)name
{
    return [super name];
}

-(void)setName:(NSString *)name
{
    return [super setName:name];
}

-(id)objectValue
{
    return [super objectValue];
}

-(void)setObjectValue:(id)value
{
    return [super setObjectValue:value];
}

-(NSString *)stringValue
{
    return [super stringValue];
}

-(void)setStringValue:(NSString *)string resolvingEntities:(BOOL)resolve
{
    return [super setStringValue:string resolvingEntities:resolve];
}

-(NSUInteger)index
{
    return [super index];
}

-(NSXMLNode *)parent
{
    return [super parent];
}

-(NSXMLNode *)childAtIndex:(NSUInteger)index
{
    return [super childAtIndex:index];
}

-(NSUInteger)childCount
{
    return [super childCount];
}

-(NSArray *)children
{
    return [super children];
}

-(void)detach
{
    return [super detach];
}

-(NSString *)localName
{
    return [super localName];
}

-(NSString *)prefix
{
    return [super prefix];
}

-(NSString *)URI
{
    return [super URI];
}

@end
