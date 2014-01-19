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

-(id) init
{
    self = [super init];
    if (self)
    {
        self.stream = [[RTTranslitStream alloc] initWithTransliterator:[[RTTransliterator alloc] initWithLanguage:@"RU"]];
    }
    return self;
}

-(void) start
{
    if (self.eventTap)
    {
        CGEventTapEnable(self.eventTap, true);
        return;
    }
    
    NSDictionary* options = @{ (__bridge id)kAXTrustedCheckOptionPrompt: @YES };
    BOOL accessibilityEnabled = AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);
    
    // TODO: mouse events
    CGEventMask eventMask = CGEventMaskBit(kCGEventKeyDown) |
                            CGEventMaskBit(kCGEventKeyUp)   |
                            CGEventMaskBit(kCGEventFlagsChanged);
    
    self.eventTap = CGEventTapCreate(kCGSessionEventTap,
                                     kCGHeadInsertEventTap,
                                     0,
                                     eventMask,
                                     RBKeyTapCallback,
                                     (__bridge void *)(self.stream));
    
    if (!self.eventTap)
    {
        NSLog(@"Failed to create event tap!");
    }
    
    CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, self.eventTap, 0);
    
    CFRunLoopAddSource(CFRunLoopGetCurrent(),
                       runLoopSource,
                       kCFRunLoopCommonModes);
    
    CGEventTapEnable(self.eventTap, true);
}

-(void) stop
{
    CGEventTapEnable(self.eventTap, false);
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
CGEventRef RBKeyTapCallback(CGEventTapProxy aProxy, CGEventType aType, CGEventRef aEvent, void* userId)
{
    if (aType != kCGEventKeyDown)
    {
        return aEvent;
    }
    
    RTTranslitStream* streamRef = (__bridge RTTranslitStream*)userId;
    
    // TODO: make static?
    UniChar* currentInputString = malloc(sizeof(UniChar) * 10);
    UniCharCount count;
    CGEventKeyboardGetUnicodeString(aEvent, 10, &count, currentInputString);
    NSString* convertedString = [NSString stringWithCharacters:currentInputString length:count];
    
    NSUInteger lengthOfCurrentCompleteTransliteratedString = [streamRef.completeTransliteratedBuffer length];
    NSUInteger lengthOfCurrentIncompleteTransliteratedString = [streamRef.incompleteTransliteratedBuffer length];
    
    // TODO: delete all text in every iteration; hacky
    RBDeleteText(lengthOfCurrentCompleteTransliteratedString + lengthOfCurrentIncompleteTransliteratedString, aEvent, aProxy, streamRef);
    
    // TODO: breaks on CMD-A
    CGEventFlags flags = CGEventGetFlags(aEvent);
    if (flags & kCGEventFlagMaskControl     ||
        flags & kCGEventFlagMaskAlternate   ||
        flags & kCGEventFlagMaskCommand     ||
        flags & kCGEventFlagMaskSecondaryFn ||
        flags & kCGEventFlagMaskHelp)
    {
        RBCommit(YES, aEvent, aProxy, streamRef);
        return aEvent;
    }
    
    [streamRef addInput:convertedString];
    
    if ([[streamRef incompleteBuffer] length] != 0 || [[streamRef completeBuffer] length] != 0)
    {
        RBCommit(NO, aEvent, aProxy, streamRef);
        
        NSString* incompleteBuffer = [streamRef incompleteBuffer];
        
        if (incompleteBuffer)
        {
            RBPrintText([streamRef incompleteTransliteratedBuffer], aEvent, aProxy, streamRef);
        }
        
        CGEventSetType(aEvent, kCGEventNull);
    }
    
    return aEvent;
}

void RBCommit(BOOL total, CGEventRef event, CGEventTapProxy proxy, RTTranslitStream* streamRef)
{
    if (!total)
    {
        NSString* completeBuffer = [streamRef completeBuffer];
        
        if (completeBuffer)
        {
            RBPrintText([streamRef completeTransliteratedBuffer], event, proxy, streamRef);
            [streamRef clearCompleteBuffer];
        }
    }
    else
    {
        NSString* totalBuffer = [streamRef totalBuffer];
        
        if (totalBuffer)
        {
            RBPrintText([streamRef totalTransliteratedBuffer], event, proxy, streamRef);
            [streamRef resetBuffer];
        }
    }
}

void RBPrintText(NSString* text, CGEventRef event, CGEventTapProxy proxy, RTTranslitStream* streamRef)
{
    UniChar string[1];
    
    for (NSUInteger i = 0; i < [text length]; i++)
    {
        string[0] = [text characterAtIndex:i];
        CGEventKeyboardSetUnicodeString(event, 1, string);
        CGEventTapPostEvent(proxy, event);
    }
}

void RBDeleteText(NSUInteger numCharacters, CGEventRef event, CGEventTapProxy proxy, RTTranslitStream* streamRef)
{
    if (numCharacters == 0)
    {
        return;
    }
    
    // kVK_Delete == 0x33, "independent of keyboard layout"
    CGEventRef keyEventDown = CGEventCreateKeyboardEvent(CGEventCreateSourceFromEvent(event), 0x33, true);
    CGEventRef keyEventUp = CGEventCreateKeyboardEvent(CGEventCreateSourceFromEvent(event), 0x33, false);
    
    for (NSUInteger i = 0; i < numCharacters; i++)
    {
        CGEventTapPostEvent(proxy, keyEventDown);
        CGEventTapPostEvent(proxy, keyEventUp);
    }
    
    CFRelease(keyEventDown);
    CFRelease(keyEventUp);
}

@end
