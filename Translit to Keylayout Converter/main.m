//
//  main.m
//  Translit to Keylayout Converter
//
//  Created by Alexei Baboulevitch on 1/20/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RKConverter.h"
#import "RTTransliterator.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        NSString* filepath = @"/Users/archagon/Documents/Programming/OSX/Russian Transliterator/Cyrillic Transliterator/Translit to Keylayout Converter/USDefault.keylayout";
        NSString* translitPath = @"/Users/archagon/Documents/Programming/OSX/Russian Transliterator/Cyrillic Transliterator/Common/RU.translit";
        NSString* outputPath = @"/Users/archagon/Documents/Programming/OSX/Russian Transliterator/Cyrillic Transliterator/Translit to Keylayout Converter/Test.keylayout";
        
        RKConverter* converter = [[RKConverter alloc] init];
        
        NSString* keylayoutContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:NULL];
        [converter loadKeylayoutXML:keylayoutContents];
        
        NSData* translitData = [NSData dataWithContentsOfFile:translitPath];
        NSDictionary* translitDict = [NSJSONSerialization JSONObjectWithData:translitData options:0 error:NULL];
        RTTransliterator* transliterator = [[RTTransliterator alloc] initWithDictionary:translitDict];
        
        NSString* modifiedKeylayoutContents = [converter convertToKeylayout:transliterator];
        [[modifiedKeylayoutContents dataUsingEncoding:NSUTF8StringEncoding] writeToFile:outputPath atomically:YES];
    }
    
    return 0;
}

