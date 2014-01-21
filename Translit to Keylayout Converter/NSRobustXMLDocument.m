//
//  NSRobustXMLDocument.m
//  Cyrillic Transliterator
//
//  Created by Alexei Baboulevitch on 1/20/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "NSRobustXMLDocument.h"
#import "NSRobustXMLNode.h"
#import "NSRobustXMLElement.h"

@implementation NSRobustXMLDocument

+(Class)replacementClassForClass:(Class)cls
{
    if (cls == [NSXMLNode class])
    {
        return [NSRobustXMLNode class];
    }
    else if (cls == [NSXMLElement class])
    {
        return [NSRobustXMLElement class];
    }
    
    return cls;
}

-(id)initWithData:(NSData *)data options:(NSUInteger)mask error:(NSError *__autoreleasing *)error
{
    return [super initWithData:data options:mask error:error];
}

-(NSXMLElement *)rootElement
{
    return [super rootElement];
}

-(void)setChildren:(NSArray *)children
{
    return [super setChildren:children];
}

-(void)removeChildAtIndex:(NSUInteger)index
{
    return [super removeChildAtIndex:index];
}

-(void)insertChild:(NSXMLNode *)child atIndex:(NSUInteger)index
{
    return [super insertChild:child atIndex:index];
}

-(NSString *)characterEncoding
{
    return [super characterEncoding];
}

-(void)setCharacterEncoding:(NSString *)encoding
{
    return [super setCharacterEncoding:encoding];
}

-(NSXMLDTD *)DTD
{
    return [super DTD];
}

-(void)setDTD:(NSXMLDTD *)documentTypeDeclaration
{
    return [super setDTD:documentTypeDeclaration];
}

-(NSString *)MIMEType
{
    return [super MIMEType];
}

-(void)setMIMEType:(NSString *)MIMEType
{
    return [super setMIMEType:MIMEType];
}

-(BOOL)isStandalone
{
    return [super isStandalone];
}

-(void)setStandalone:(BOOL)standalone
{
    return [super setStandalone:standalone];
}

-(NSString *)version
{
    return [super version];
}

-(void)setURI:(NSString *)URI
{
    return [super setURI:URI];
}

-(void)setVersion:(NSString *)version
{
    return [super setVersion:version];
}

@end
