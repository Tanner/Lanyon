//
//  DHLPost.m
//  Lanyon
//
//  Created by Tanner Smith on 1/2/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import <YAML/YAMLSerialization.h>

#import "DHLPost.h"

@implementation DHLPost

@synthesize path, contents;
@synthesize yaml, text, parsedYAML;

- (id)initWithPath:(NSURL *)aPath {
    if (self = [super init]) {
        path = aPath;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSData *data = [fileManager contentsAtPath:(NSString *) path];
        
        contents = [[NSString alloc] initWithBytes:[data bytes]
                                            length:[data length]
                                          encoding:NSUTF8StringEncoding];
        
        NSArray *components = [contents componentsSeparatedByString:@"---"];
        
        yaml = components[1];
        text = components[2];
        
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        yaml = [NSString stringWithFormat:@"---%@---", yaml];
        
        parsedYAML = [[YAMLSerialization objectsWithYAMLString:yaml
                                                      options:kYAMLReadOptionStringScalars
                                                        error:nil] objectAtIndex:0];
    }
    
    return self;
}

@end
