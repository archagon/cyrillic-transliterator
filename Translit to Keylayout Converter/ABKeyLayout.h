//
//  ABKeyLayout.h
//  Cyrillic Transliterator
//
//  Created by Alexei Baboulevitch on 1/20/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

// Based on notes: https://developer.apple.com/library/mac/technotes/tn2056/_index.html

//////////////////////////////////////////

@interface ABMutableKeyLayout : NSObject

@property NSString* name;
@property NSInteger group;
@property NSInteger identifier; // 'id'
@property NSInteger maxout;

@property NSMutableArray* layouts; // collection of ABKeyLayoutHardwareKeyboardMap (maps to 'layout' in XML)
@property ABKeyLayoutModifierMap* modifierMap;
@property NSMutableArray* keyMapSet;
@property NSMutableArray* actions;
@property NSMutableArray* terminators;

@end

//////////////////////////////////////////

@interface ABKeyLayoutHardwareKeyboardMap

-(id) initWithFirst:(NSInteger)first last:(NSInteger)last modifierMap:(NSString*)modifierMap keyMapSet:(NSString*)keyMapSet;

@property NSInteger first;
@property NSInteger last;
@property NSString* modifierMap;
@property NSString* keyMapSet;

@end

//////////////////////////////////////////

@interface ABKeyLayoutModifierMap

@property NSString* identifier; // 'id'
@property NSString* defaultIndex;

@end

//////////////////////////////////////////


