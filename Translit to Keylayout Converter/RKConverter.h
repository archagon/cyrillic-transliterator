//
//  RKConverter.h
//  Cyrillic Transliterator
//
//  Created by Alexei Baboulevitch on 1/20/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

@interface RKConverter : NSObject

-(BOOL) loadKeylayoutXML:(NSString*)keylayoutXMLContents;
-(NSString*) convertToKeylayout:(NSDictionary*)translitBindings;

@end
