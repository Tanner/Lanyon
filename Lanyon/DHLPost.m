//
//  DHLPost.m
//  Lanyon
//
//  Created by Tanner Smith on 1/2/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import "DHLPost.h"

@implementation DHLPost

@synthesize path, contents;
@synthesize yaml, text;

- (id)initWithPath:(NSString *)aPath {
    if (self = [super init]) {
        path = aPath;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSData *data = [fileManager contentsAtPath:path];
        
        contents = [[NSString alloc] initWithBytes:[data bytes]
                                            length:[data length]
                                          encoding:NSUTF8StringEncoding];
        
        NSArray *components = [contents componentsSeparatedByString:@"---"];
        
        yaml = components[1];
        text = components[2];
    }
    
    return self;
}

@end
