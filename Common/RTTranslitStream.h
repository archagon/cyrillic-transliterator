//
//  RTTranslitStream.h
//  Russian Transliterator
//
//  Created by Alexei Baboulevitch on 1/17/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

@interface RTTranslitStream : NSObject

@property (nonatomic) NSMutableString* buffer;
@property (nonatomic) NSMutableString* transliteratedBuffer;

-(void) resetBuffer;

@end
