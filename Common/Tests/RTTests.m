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
    RTTransliterator* transliterator = [[RTTransliterator alloc] initWithPlistPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"RU" ofType:@"plist"]];
    
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
    RTTransliterator* transliterator = [[RTTransliterator alloc] initWithPlistPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"ZZ" ofType:@"plist"]];
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
    XCTAssertTrue([[stream completeBuffer] isEqualToString:@""], @"expected nil complete buffer");
    
    [stream addInput:@"e"];
    [self assertTransliterationWithOriginal:@"azzyoge" result:[stream totalTransliteratedBuffer] expected:@"D"];
    XCTAssertTrue([[stream completeBuffer] isEqualToString:@"azzyoge"], @"expected full complete buffer");
    XCTAssertTrue([[stream completeTransliteratedBuffer] isEqualToString:@"D"], @"expected full complete translit");
    XCTAssertTrue([[stream incompleteBuffer] isEqualToString:@""], @"expected nil incomplete buffer");
    XCTAssertTrue([[stream incompleteTransliteratedBuffer] isEqualToString:@""], @"expected nil incomplete translit");
    
    [stream addInput:@"a"];
    [self assertTransliterationWithOriginal:@"azzyogea" result:[stream totalTransliteratedBuffer] expected:@"D1"];
    XCTAssertTrue([[stream completeBuffer] isEqualToString:@"azzyoge"], @"expected full complete buffer");
    XCTAssertTrue([[stream completeTransliteratedBuffer] isEqualToString:@"D"], @"expected full complete translit");
    XCTAssertTrue([[stream incompleteBuffer] isEqualToString:@"a"], @"expected populated incomplete buffer");
    XCTAssertTrue([[stream incompleteTransliteratedBuffer] isEqualToString:@"1"], @"expected populated incomplete translit");
}

-(void) testStressTest2
{
    RTTransliterator* transliterator = [[RTTransliterator alloc] initWithPlistPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"ZZ" ofType:@"plist"]];
    RTTranslitStream* stream = [[RTTranslitStream alloc] initWithTransliterator:transliterator];
    
    [stream addInput:@"a"];
    [self assertTransliterationWithOriginal:@"a" result:[stream totalTransliteratedBuffer] expected:@"1"];
    
    [stream addInput:@"y"];
    [self assertTransliterationWithOriginal:@"ay" result:[stream totalTransliteratedBuffer] expected:@"19"];
    
    [stream addInput:@"e"];
    [self assertTransliterationWithOriginal:@"aye" result:[stream totalTransliteratedBuffer] expected:@"6"];
    
    [stream addInput:@"g"];
    [self assertTransliterationWithOriginal:@"ayeg" result:[stream totalTransliteratedBuffer] expected:@"64"];
    
    [stream addInput:@"o"];
    [self assertTransliterationWithOriginal:@"ayego" result:[stream totalTransliteratedBuffer] expected:@"64B"];
    
    [stream addInput:@"r"];
    [self assertTransliterationWithOriginal:@"ayegor" result:[stream totalTransliteratedBuffer] expected:@"64BC"];
    XCTAssertTrue([[stream completeBuffer] isEqualToString:@""], @"expected nil complete buffer");
    
    [stream addInput:@"e"];
    [self assertTransliterationWithOriginal:@"ayegore" result:[stream totalTransliteratedBuffer] expected:@"8"];
    XCTAssertTrue([[stream completeBuffer] isEqualToString:@"ayegore"], @"expected full complete buffer");
    XCTAssertTrue([[stream completeTransliteratedBuffer] isEqualToString:@"8"], @"expected full complete translit");
    XCTAssertTrue([[stream incompleteBuffer] isEqualToString:@""], @"expected nil incomplete buffer");
    XCTAssertTrue([[stream incompleteTransliteratedBuffer] isEqualToString:@""], @"expected nil incomplete translit");
    
    [stream addInput:@"a"];
    [self assertTransliterationWithOriginal:@"ayegorea" result:[stream totalTransliteratedBuffer] expected:@"81"];
    XCTAssertTrue([[stream completeBuffer] isEqualToString:@"ayegore"], @"expected full complete buffer");
    XCTAssertTrue([[stream completeTransliteratedBuffer] isEqualToString:@"8"], @"expected full complete translit");
    XCTAssertTrue([[stream incompleteBuffer] isEqualToString:@"a"], @"expected populated incomplete buffer");
    XCTAssertTrue([[stream incompleteTransliteratedBuffer] isEqualToString:@"1"], @"expected populated incomplete translit");
}

-(void) assertTransliterationWithOriginal:(NSString*)original result:(NSString*)result expected:(NSString*)expected
{
    XCTAssertTrue([result isEqualToString:expected], @"translit failed for \"%@\": expected \"%@\", got \"%@\"", original, expected, result);
}

@end
