//
//  RTTests.m
//  Russian Transliterator Input Method
//
//  Created by Alexei Baboulevitch on 1/17/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RTTransliterator.h"

@interface RTTests : XCTestCase
@property (nonatomic) RTTransliterator* transliterator;
@end

@implementation RTTests

-(void) setUp
{
    [super setUp];
    self.transliterator = [[RTTransliterator alloc] initWithLanguage:@"RU"];
}

-(void) tearDown
{
    self.transliterator = nil;
    [super tearDown];
}

-(void) testBasicTransliteration
{
    NSArray* testStrings = @[@"s", @"sh", @"shh", @"shhh"];
    NSArray* translitStrings = @[@"с", @"ш", @"щ", [NSNull null]];
    NSArray* nextValues = @[@YES, @YES, @NO, @NO];
    
    for (NSUInteger i = 0; i < [testStrings count]; i++)
    {
        NSString* testValue = testStrings[i];
        NSString* transliteratedValue = [self.transliterator currentValueForString:testValue];
        NSString* expectedTransliteration = (translitStrings[i] != [NSNull null] ? translitStrings[i] : nil);
        BOOL expectedValue = [nextValues[i] boolValue];
        
        XCTAssertTrue((!transliteratedValue ? transliteratedValue == expectedTransliteration :[transliteratedValue isEqualToString:expectedTransliteration]), @"translit failed for \"%@\": expected \"%@\", got \"%@\"", testValue, expectedTransliteration, transliteratedValue);
        
        if (expectedValue)
        {
            XCTAssertTrue([self.transliterator hasNext:testValue], @"translit failed for \"s\" hasNext, expected true");
        }
        else
        {
            XCTAssertFalse([self.transliterator hasNext:testValue], @"translit failed for \"s\" hasNext, expected false");
        }
    }
}

@end
