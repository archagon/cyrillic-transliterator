//
//  Transliterator.h
//  Cyrillic Transliterator
//
//  Created by Alexei Baboulevitch on 1/16/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

@interface RTTransliterator : NSObject

@property (nonatomic, readonly) NSDictionary* languageTree;
@property (nonatomic, readonly) NSUInteger longestKeyLength;

-(id) initWithLanguage:(NSString*)language;
-(id) initWithPlistPath:(NSString*)path;

-(NSString*) currentValueForString:(NSString*)string;
-(NSArray*) nextPossibleLettersForString:(NSString*)string;
-(BOOL) hasNext:(NSString*)string;

@end
