//
//  RMInputController.h
//  Cyrillic Transliterator Input Method
//
//  Created by Alexei Baboulevitch on 1/15/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RTTransliterator.h"

@interface RMInputController : IMKInputController

@property (nonatomic) RTTransliterator* transliterator;
@property (nonatomic) NSMutableString* buffer;
@property (nonatomic) NSString* processedBuffer;

@end
