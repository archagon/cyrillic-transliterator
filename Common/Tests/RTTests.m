//
//  RTTests.m
//  Cyrillic Transliterator
//
//  Created by Alexei Baboulevitch on 1/17/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RTTransliterator.h"
#import "RTTranslitStream.h"

@interface RTTests : XCTestCase
@end

@implementation RTTests

-(void) setUp
{
    [super setUp];
}

-(void) tearDown
{
    [super tearDown];
}

-(void) testBasicTransliteration
{
    RTTransliterator* transliterator = [[RTTransliterator alloc] initWithLanguage:@"RU"];
    
    NSArray* testStrings = @[@"s", @"sh", @"shh", @"shhh"];
    NSArray* translitStrings = @[@"с", @"ш", @"щ", [NSNull null]];
    NSArray* nextValues = @[@YES, @YES, @NO, @NO];
    
    for (NSUInteger i = 0; i < [testStrings count]; i++)
    {
        NSString* testValue = testStrings[i];
        NSString* transliteratedValue = [transliterator currentValueForString:testValue];
        NSString* expectedTransliteration = (translitStrings[i] != [NSNull null] ? translitStrings[i] : nil);
        BOOL expectedValue = [nextValues[i] boolValue];
        
        XCTAssertTrue((!transliteratedValue ? transliteratedValue == expectedTransliteration :[transliteratedValue isEqualToString:expectedTransliteration]), @"translit failed for \"%@\": expected \"%@\", got \"%@\"", testValue, expectedTransliteration, transliteratedValue);
        
        if (expectedValue)
        {
            XCTAssertTrue([transliterator hasNext:testValue], @"translit failed for \"s\" hasNext, expected true");
        }
        else
        {
            XCTAssertFalse([transliterator hasNext:testValue], @"translit failed for \"s\" hasNext, expected false");
        }
    }
}

-(void) testStressTest1
{
    RTTransliterator* transliterator = [[RTTransliterator alloc] initWithLanguage:@"ZZ"];
    RTTranslitStream* stream = [[RTTranslitStream alloc] initWithTransliterator:transliterator];
    
    [stream addInput:@"a"];
    [self assertTransliterationWithOriginal:@"a" result:[stream totalTransliteratedBuffer] expected:@"1"];
    
    [stream addInput:@"z"];
    [self assertTransliterationWithOriginal:@"az" result:[stream totalTransliteratedBuffer] expected:@"12"];
    
    [stream addInput:@"z"];
    [self assertTransliterationWithOriginal:@"azz" result:[stream totalTransliteratedBuffer] expected:@"122"];
    
    [stream addInput:@"y"];
    [self assertTransliterationWithOriginal:@"azzy" result:[stream totalTransliteratedBuffer] expected:@"1229"];
    
    [stream addInput:@"o"];
    [self assertTransliterationWithOriginal:@"azzyo" result:[stream totalTransliteratedBuffer] expected:@"1223"];
    
    [stream addInput:@"g"];
    [self assertTransliterationWithOriginal:@"azzyog" result:[stream totalTransliteratedBuffer] expected:@"5"];
    
    [stream addInput:@"e"];
    [self assertTransliterationWithOriginal:@"azzyoge" result:[stream totalTransliteratedBuffer] expected:@"D"];
}

-(void) assertTransliterationWithOriginal:(NSString*)original result:(NSString*)result expected:(NSString*)expected
{
    XCTAssertTrue([result isEqualToString:expected], @"translit failed for \"%@\": expected \"%@\", got \"%@\"", original, expected, result);
}

@end
