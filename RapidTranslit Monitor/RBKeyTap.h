//
//  RBKeyTap.h
//  Cyrillic Transliterator
//
//  Created by Alexei Baboulevitch on 1/18/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RTTranslitStream.h"

@interface RBKeyTap : NSObject

@property RTTranslitStream* stream;

-(void) start;
-(void) stop;

@end
