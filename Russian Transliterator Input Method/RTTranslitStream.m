//
//  RTTranslitStream.m
//  Russian Transliterator
//
//  Created by Alexei Baboulevitch on 1/17/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RTTranslitStream.h"

@implementation RTTranslitStream

-(void) resetBuffer
{
    [self.buffer deleteCharactersInRange:NSMakeRange(0, [self.buffer length])];
    [self.transliteratedBuffer deleteCharactersInRange:NSMakeRange(0, [self.buffer length])];
}

@end
