//
//  main.m
//  Translit to Keylayout Converter
//
//  Created by Alexei Baboulevitch on 1/20/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

#import "RKConverter.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        NSString* filepath = @"/Users/archagon/Documents/Programming/OSX/Russian Transliterator/Cyrillic Transliterator/Translit to Keylayout Converter/USDefault.keylayout";
        
        RKConverter* converter = [[RKConverter alloc] init];
        
        NSString* keylayoutContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:NULL];
        [converter loadKeylayoutXML:keylayoutContents];
        
        NSString* modifiedKeylayoutContents = [converter convertToKeylayout:nil];
        [[modifiedKeylayoutContents dataUsingEncoding:NSUTF8StringEncoding] writeToFile:@"/Users/archagon/Documents/Programming/OSX/Russian Transliterator/Cyrillic Transliterator/Translit to Keylayout Converter/Test.keylayout" atomically:YES];
    }
    
    return 0;
}

