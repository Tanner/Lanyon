//
//  DHLJekyllConfig.m
//  Lanyon
//
//  Created by Tanner Smith on 1/23/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import <YAML/YAMLSerialization.h>

#import "DHLJekyllConfig.h"

@implementation DHLJekyllConfig

@synthesize path, contents;

- (id)initWithPath:(NSString *)aPath {
    if (self = [super init]) {
        path = [aPath stringByAppendingPathComponent:@"_config.yml"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSData *data = [fileManager contentsAtPath:(NSString *) path];
        
        NSString *yaml = [[NSString alloc] initWithBytes:[data bytes]
                                            length:[data length]
                                          encoding:NSUTF8StringEncoding];
                
        yaml = [NSString stringWithFormat:@"%@---", yaml];
        
        contents = [[YAMLSerialization objectsWithYAMLString:yaml
                                                       options:kYAMLReadOptionStringScalars
                                                         error:nil] objectAtIndex:0];
    }
    
    return self;
}

- (NSDictionary *)contents {
    return contents;
}

@end
