//
//  RKConverter.m
//  Cyrillic Transliterator
//
//  Created by Alexei Baboulevitch on 1/20/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RKConverter.h"
#import "NSRobustXMLDocument.h"

// TODO: grab current keyboard layout, a la Ukelele: http://stackoverflow.com/questions/1918841/how-to-convert-ascii-character-to-cgkeycode
// TODO: accomodate existing state changes
// TODO: keyboards that output multiple characters per keystroke?

@interface RKConverter ()

@property NSXMLDocument* keylayoutXML;

-(NSString*) createOutputKeylayoutXML;
-(BOOL) stripKeylayoutActions;
-(BOOL) parseTransliterator:(RTTransliterator*)transliterator;
-(BOOL) parseTransliterator:(RTTransliterator*)transliterator withString:(NSString*)string;

@end

@implementation RKConverter

-(BOOL) loadKeylayoutXML:(NSString*)keylayoutXMLContents;
{
    NSError* error = nil;

    // validation seems to not work; I don't know much about DTDs, but I wonder if Apple's is valid?
    
    //NSData* dtdData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"file://localhost/System/Library/DTDs/KeyboardLayout.dtd"]];
    //NSXMLDTD* dtd = [[NSXMLDTD alloc] initWithData:dtdData options:0 error:&error];
    //[self.keylayoutXML setDTD:dtd];
    
    // Apple's XML is invalid because they include control characters encoded as hex; since most XML parsers won't
    // allow that, we have to temporarily take them out and then put them back in at the end
    
    NSRegularExpression* controlCharacterRegex = [NSRegularExpression regularExpressionWithPattern:@"&#x([0-9a-fA-F]+);" options:0 error:&error];
    NSString* xmlWithoutControlCharacters = [controlCharacterRegex stringByReplacingMatchesInString:keylayoutXMLContents options:0 range:NSMakeRange(0, [keylayoutXMLContents length]) withTemplate:@"(KeyLayout Character: $1)"];
    
    self.keylayoutXML = [[NSXMLDocument alloc] initWithXMLString:xmlWithoutControlCharacters options:0 error:&error];
    //[self.keylayoutXML validateAndReturnError:&error];
    
    return (!error ? YES : NO);
}

-(NSString*) createOutputKeylayoutXML
{
    NSError* error = nil;
    
    NSString* outputXML = [self.keylayoutXML XMLStringWithOptions:NSXMLNodePreserveAll|NSXMLNodePrettyPrint];
    
    NSRegularExpression* outputRegex = [NSRegularExpression regularExpressionWithPattern:@"[(]KeyLayout Character: ([0-9a-fA-F]*)[)]" options:0 error:&error];
    NSString* modifiedOutputString = [outputRegex stringByReplacingMatchesInString:outputXML options:0 range:NSMakeRange(0, [outputXML length]) withTemplate:@"&#x$1;"];
    
    return modifiedOutputString;
}

// TODO: make recursive
-(BOOL) stripKeylayoutActions
{
    NSError* error = nil;
    
    NSArray* keys = [self.keylayoutXML nodesForXPath:@"/keyboard/keyMapSet/keyMap/key" error:&error];
    
    for (NSXMLElement* key in keys)
    {
        NSXMLNode* actionId = [key attributeForName:@"action"];
        
        if ([key attributeForName:@"action"])
        {
            NSString* actionXPath = [NSString stringWithFormat:@"/keyboard/actions/action[@id='%@']/when[@state='none']", [actionId stringValue]];
            NSArray* actions = [self.keylayoutXML nodesForXPath:actionXPath error:&error];
            
            if (actions && [actions count] > 0)
            {
                NSXMLElement* action = actions[0];
                NSXMLNode* nextId = [action attributeForName:@"next"];
                
                if (nextId)
                {
                    NSString* terminatorXPath = [NSString stringWithFormat:@"/keyboard/terminators/when[@state='%@']", [nextId stringValue]];
                    NSArray* terminators = [self.keylayoutXML nodesForXPath:terminatorXPath error:&error];
                    
                    if (terminators && [terminators count] > 0)
                    {
                        NSXMLElement* terminator = terminators[0];
                        NSXMLNode* outputId = [terminator attributeForName:@"output"];
                        
                        if (outputId)
                        {
                            NSXMLNode* outputAttribute = [NSXMLNode attributeWithName:@"output" stringValue:[outputId stringValue]];
                            [key removeAttributeForName:@"action"];
                            [key addAttribute:outputAttribute];
                        }
                        else
                        {
                            // no output in terminator, wtf?
                        }
                    }
                }
                else
                {
                    NSXMLNode* outputId = [action attributeForName:@"output"];
                    
                    if (outputId)
                    {
                        NSXMLNode* outputAttribute = [NSXMLNode attributeWithName:@"output" stringValue:[outputId stringValue]];
                        [key removeAttributeForName:@"action"];
                        [key addAttribute:outputAttribute];
                    }
                    else
                    {
                        // no output, no next, wtf?
                    }
                }
            }
            else
            {
                // action has no "none" state
                [key detach];
            }
        }
    }
    
    NSArray* actions = [self.keylayoutXML nodesForXPath:@"/keyboard/actions/action" error:&error];
    
    for (NSXMLElement* action in actions)
    {
        [action detach];
    }
    
//    NSArray* actions = [self.keylayoutXML nodesForXPath:@"/keyboard/actions" error:&error];
//    
//    if ([actions count] > 0)
//    {
//        [actions[0] detach];
//    }
    
    NSArray* terminators = [self.keylayoutXML nodesForXPath:@"/keyboard/terminators/when" error:&error];
    
    for (NSXMLElement* terminator in terminators)
    {
        [terminator detach];
    }
    
    return YES;
}

-(NSXMLElement*) actionForString:(NSString*)string
{
    NSString* actionName = [NSString stringWithFormat:@"action-%@", string];
    NSString* actionXPath = [NSString stringWithFormat:@"/keyboard/actions/action[@id='%@']", actionName];
    NSXMLElement* action = [self getNodeForXPath:actionXPath];
    
    if (action)
    {
        return action;
    }
    else
    {
        NSString* actionsXPath = [NSString stringWithFormat:@"/keyboard/actions"];
        NSXMLElement* actions = [self getNodeForXPath:actionsXPath];
        
        action = [NSXMLElement elementWithName:@"action"];
        NSXMLNode* outputAttribute = [NSXMLNode attributeWithName:@"id" stringValue:actionName];
        [action addAttribute:outputAttribute];
        
        [actions addChild:action];
        
        return action;
    }
}

-(NSXMLElement*) stateForString:(NSString*)string
{
    return nil;
}

-(BOOL) addTerminator:(NSString*)terminatorValue forState:(NSString*)state
{
    NSString* terminatorXPath = [NSString stringWithFormat:@"/keyboard/terminators/when[@state='%@']", state];
    NSXMLElement* terminator = [self getNodeForXPath:terminatorXPath];
    
    if (terminator)
    {
        NSXMLNode* outputAttribute = [terminator attributeForName:@"output"];
        [outputAttribute setStringValue:terminatorValue];
        return YES;
    }
    else
    {
        NSString* terminatorsXPath = [NSString stringWithFormat:@"/keyboard/terminators"];
        NSXMLElement* terminators = [self getNodeForXPath:terminatorsXPath];
        
        NSXMLElement* when = [NSXMLElement elementWithName:@"when"];
        NSXMLNode* stateAttribute = [NSXMLNode attributeWithName:@"state" stringValue:state];
        NSXMLNode* outputAttribute = [NSXMLNode attributeWithName:@"output" stringValue:terminatorValue];
        [when addAttribute:outputAttribute];
        [when addAttribute:stateAttribute];
        
        [terminators addChild:when];
        
        return YES;
    }
}

-(id) getNodeForXPath:(NSString*)xpath
{
    NSError* error;
    NSArray* nodes = [self.keylayoutXML nodesForXPath:xpath error:&error];

    if (nodes && [nodes count] > 0)
    {
        return nodes[0];
    }
    else
    {
        return nil;
    }
}

-(BOOL) parseTransliterator:(RTTransliterator*)transliterator
{
    BOOL result = YES;
    
    for (NSString* letter in [transliterator startingLetters])
    {
        BOOL letterResult = [self parseTransliterator:transliterator withString:letter];
        result = (result ? letterResult : NO);
    }
    
    return result;
}

-(BOOL) parseTransliterator:(RTTransliterator*)transliterator withString:(NSString*)string
{
    NSString* value = [transliterator currentValueForString:string];
    NSArray* nextLetters = [transliterator nextPossibleLettersForString:string];
    
    if ([string length] == 1)
    {
        [self actionForString:string];
    }
    
    if (value && [nextLetters count] > 0)
    {
        [self addTerminator:value forState:[NSString stringWithFormat:@"state-%@", string]];
    }
    
    for (NSString* letter in nextLetters)
    {
        [self parseTransliterator:transliterator withString:[string stringByAppendingString:letter]];
    }
    
    return YES;
}

-(NSString*) convertToKeylayout:(RTTransliterator*)transliterator
{
    if (!self.keylayoutXML)
    {
        // TODO: error
        return nil;
    }
    
    [self stripKeylayoutActions];
    [self parseTransliterator:transliterator];
    
    return [self createOutputKeylayoutXML];
}

@end
