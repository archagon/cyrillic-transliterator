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

@interface RKConverter ()

@property NSXMLDocument* keylayoutXML;

-(NSString*) createOutputKeylayoutXML;
-(BOOL) stripKeylayoutActions;

@end

@implementation RKConverter

-(BOOL) loadKeylayoutXML:(NSString*)keylayoutXMLContents;
{
    NSError* error = nil;

    //NSData* dtdData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"file://localhost/System/Library/DTDs/KeyboardLayout.dtd"]];
    //NSXMLDTD* dtd = [[NSXMLDTD alloc] initWithData:dtdData options:0 error:&error];
    //[self.keylayoutXML setDTD:dtd];
    
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
            NSLog(@"is action: %@", [actionId stringValue]);
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
                            NSLog(@"Changing key to %@", [outputId stringValue]);
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
                        NSLog(@"Changing key to %@", [outputId stringValue]);
                    }
                    else
                    {
                        // no output, no next, wtf?
                    }
                }
            }
        }
    }
    
//    NSArray* actions = [self.keylayoutXML nodesForXPath:@"/keyboard/actions/action" error:&error];
//    
//    for (NSXMLElement* action in actions)
//    {
//        [action detach];
//    }
    
    NSArray* actions = [self.keylayoutXML nodesForXPath:@"/keyboard/actions" error:&error];
    
    if ([actions count] > 0)
    {
        [actions[0] detach];
    }
    
    return YES;
}

-(NSString*) convertToKeylayout:(NSDictionary*)translitBindings
{
    if (!self.keylayoutXML)
    {
        // TODO: error
        return nil;
    }
    
    [self stripKeylayoutActions];
    
    return [self createOutputKeylayoutXML];
}

@end
