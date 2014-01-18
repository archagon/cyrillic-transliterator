//
//  RTTranslitStream.h
//  Cyrillic Transliterator
//
//  Created by Alexei Baboulevitch on 1/17/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RTTransliterator.h"

@interface RTTranslitStream : NSObject

// My transliteration engine is greedy, in the sense that it will swallow as many characters as possible for every
// letter, with a left-to-right priority. Here's what I mean: if I have the string "ayegor", and we have transliteration
// matches for the substrings "aye", "yego", as well as each individual letter, then the engine will match "aye" and then
// "g", "o", and "r". "yego" won't be matched, even though it's longer than "aye", because the substring starting
// with the character "a" takes priority.

// Because we're treating our transliteration as an arbitrary stream of characters, we can't just transliterate
// the entire buffer at once and be done with it. Again, let's say we have the string "ayegor" and we have an additional
// transliteration match for "ayegore". Since we're greedy, we can't simply tell our user to go ahead and commit
// the transliteration we have, since the next letter could be "e" and then our entire buffer would condense down
// to the transliteration match. We need to divide our buffer into two parts: one part that is complete and can
// have no further matches, and another part that still has the potential to condense down further. Note that
// BOTH parts, not just the complete part, needs to have a transliteration buffer, since we also want to transliterate
// the user's input in real-time, as best as possible; in other words, we want the user to see the transliteration
// for "aye", "g", "o", and "r", even though if they enter "e", the entire transliteration will change.

// To use this class, add user input with the addInput: method. This will cause the buffers to fill accordingly.
// When you're ready to commit, check the completeBuffer property. If there's anything in it, feel free to grab
// the complete buffers and call the clearCompleteBuffer method. If you want the complete buffer and transliteration,
// you can simply combine the complete and incomplete buffers.

@property (nonatomic, readonly) NSMutableString* completeBuffer;
@property (nonatomic, readonly) NSMutableString* completeTransliteratedBuffer;
@property (nonatomic, readonly) NSMutableString* incompleteBuffer;
@property (nonatomic, readonly) NSMutableString* incompleteTransliteratedBuffer;

-(id) initWithTransliterator:(RTTransliterator*)transliterator;
-(void) addInput:(NSString*)string;
-(NSString*) totalBuffer;
-(NSString*) totalTransliteratedBuffer;
-(void) clearCompleteBuffer;
-(void) resetBuffer;

@end
