//
//  RBKeyTap.m
//  Cyrillic Transliterator
//
//  Created by Alexei Baboulevitch on 1/18/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RBKeyTap.h"
#import "RTTransliterator.h"
#import "UIElementUtilities.h"

// http://stackoverflow.com/questions/19798583/accessibility-api-alternative-to-get-selected-text-from-any-app-in-osx

@implementation RBKeyTap

UniChar* currentInputString;
RTTranslitStream* streamRef;

-(id) init
{
    self = [super init];
    if (self)
    {
        self.stream = [[RTTranslitStream alloc] initWithTransliterator:[[RTTransliterator alloc] initWithLanguage:@"RU"]];
        streamRef = self.stream;
        currentInputString = malloc(sizeof(UniChar) * 10);
    }
    return self;
}

-(void) start
{
    NSDictionary* options = @{ (__bridge id)kAXTrustedCheckOptionPrompt: @YES };
    BOOL accessibilityEnabled = AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);
    
    CGEventMask eventMask = CGEventMaskBit(kCGEventKeyDown) |
                            CGEventMaskBit(kCGEventKeyUp)   |
                            CGEventMaskBit(kCGEventFlagsChanged);
    
    CFMachPortRef eventTap = CGEventTapCreate(kCGSessionEventTap,
                                                 kCGHeadInsertEventTap,
                                                 0,
                                                 eventMask,
                                                 RBKeyTapCallback,
//                                                 @[ currentInputString, self ]);
                                                 NULL);
    
    if (!eventTap)
    {
        NSLog(@"Failed to create event tap!");
    }
    
    CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
    
    CFRunLoopAddSource(CFRunLoopGetCurrent(),
                       runLoopSource,
                       kCFRunLoopCommonModes);
    
    CGEventTapEnable(eventTap, true);
}

-(void) stop
{
}

//-(void) accessibilityTest
//{
//    AXUIElementRef _systemWide = AXUIElementCreateSystemWide();
//    
//    // get the currently active application
//    AXUIElementRef _app = (__bridge AXUIElementRef)[UIElementUtilities
//                                                    valueOfAttribute:@"AXFocusedApplication"
//                                                    ofUIElement:_systemWide];
//    
//    // Get the window that has focus for this application
//    AXUIElementRef _window = (__bridge AXUIElementRef)[UIElementUtilities
//                                                       valueOfAttribute:@"AXFocusedUIElement"
//                                                       ofUIElement:_app];
//    
//    NSString *valueToSet = @"this is a test";
//    AXUIElementSetAttributeValue(_window, kAXValueAttribute, (__bridge CFTypeRef)(valueToSet));
//}

// TODO: can we keep this inside the interface declaration?
CGEventRef RBKeyTapCallback(CGEventTapProxy aProxy, CGEventType aType, CGEventRef aEvent, void* aRefcon)
{
    if (aType != kCGEventKeyDown)
    {
        return aEvent;
    }
    
    UniCharCount count;
    
    CGEventKeyboardGetUnicodeString(aEvent, 10, &count, currentInputString);
    NSString* convertedString = [NSString stringWithCharacters:currentInputString length:count];
    
    NSUInteger lengthOfCurrentCompleteTransliteratedString = [streamRef.completeTransliteratedBuffer length];
    NSUInteger lengthOfCurrentIncompleteTransliteratedString = [streamRef.incompleteTransliteratedBuffer length];
    
    // TODO: delete all text in every iteration; hacky
    RBDeleteText(lengthOfCurrentCompleteTransliteratedString + lengthOfCurrentIncompleteTransliteratedString, aEvent, aProxy);
    
    [streamRef addInput:convertedString];
    
    if ([[streamRef incompleteBuffer] length] != 0 || [[streamRef completeBuffer] length] != 0)
    {
        RBCommit(NO, aEvent, aProxy);
        
        NSString* incompleteBuffer = [streamRef incompleteBuffer];
        
        if (incompleteBuffer)
        {
            RBPrintText([streamRef incompleteTransliteratedBuffer], aEvent, aProxy);
//            [sender setMarkedText:[self.stream incompleteTransliteratedBuffer] selectionRange:NSMakeRange(0, [incompleteBuffer length]) replacementRange:NSMakeRange(NSNotFound, NSNotFound)];
        }
        
        UniChar string[1];
        string[0] = '\0';
        CGEventKeyboardSetUnicodeString(aEvent, 1, string);
    }
    
    return aEvent;
}

void RBCommit(BOOL total, CGEventRef event, CGEventTapProxy proxy)
{
    if (!total)
    {
        NSString* completeBuffer = [streamRef completeBuffer];
        
        if (completeBuffer)
        {
            RBPrintText([streamRef completeTransliteratedBuffer], event, proxy);
            [streamRef clearCompleteBuffer];
        }
    }
    else
    {
        NSString* totalBuffer = [streamRef totalBuffer];
        
        if (totalBuffer)
        {
            RBPrintText([streamRef totalTransliteratedBuffer], event, proxy);
            [streamRef resetBuffer];
        }
    }
}

void RBPrintText(NSString* text, CGEventRef event, CGEventTapProxy proxy)
{
    UniChar string[1];
    
    for (NSUInteger i = 0; i < [text length]; i++)
    {
        string[0] = [text characterAtIndex:i];
        CGEventKeyboardSetUnicodeString(event, 1, string);
        CGEventTapPostEvent(proxy, event);
    }
}

void RBDeleteText(NSUInteger numCharacters, CGEventRef event, CGEventTapProxy proxy)
{
    if (numCharacters == 0)
    {
        return;
    }
    
    numCharacters++;
    
    // kVK_Delete == 0x33, "independent of keyboard layout"
    CGEventRef keyEventDown = CGEventCreateKeyboardEvent(CGEventCreateSourceFromEvent(event), 0x33, true);
    CGEventRef keyEventUp = CGEventCreateKeyboardEvent(CGEventCreateSourceFromEvent(event), 0x33, false);
    
    for (NSUInteger i = 0; i < numCharacters; i++)
    {
        CGEventTapPostEvent(proxy, keyEventDown);
        CGEventTapPostEvent(proxy, keyEventUp);
    }
}

@end
