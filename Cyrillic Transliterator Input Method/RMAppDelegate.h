//
//  RMAppDelegate.h
//  Cyrillic Transliterator Input Method
//
//  Created by Alexei Baboulevitch on 1/15/14.
//  Copyright (c) 2014 Alexei Baboulevitch. All rights reserved.
//

@interface RMAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, retain) NSString* connectionName;
@property (nonatomic, retain) IMKServer* server;

@end
