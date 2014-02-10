//
//  DHLPost.m
//  Lanyon
//
//  Created by Tanner Smith on 1/2/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import <YAML/YAMLSerialization.h>

#import "DHLPost.h"

#import "DHLTag.h"

@implementation DHLPost

@synthesize path, contents;
@synthesize yaml, text;
@synthesize title, date, layout, permalink, published, categories, tags;

- (id)initWithPath:(NSURL *)aPath {
    if (self = [super init]) {
        path = aPath;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSData *data = [fileManager contentsAtPath:(NSString *) path];
        
        contents = [[NSString alloc] initWithBytes:[data bytes]
                                            length:[data length]
                                          encoding:NSUTF8StringEncoding];
        
        NSArray *components = [contents componentsSeparatedByString:@"---"];
        
        NSString *rawYAML = components[1];
        text = components[2];
        
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        rawYAML = [NSString stringWithFormat:@"---%@---", rawYAML];
        
        yaml = [[YAMLSerialization objectsWithYAMLString:rawYAML
                                                      options:kYAMLReadOptionStringScalars
                                                        error:nil] objectAtIndex:0];

        // Common front matter
        title = [yaml objectForKey:@"title"];
        date = [NSDate dateWithNaturalLanguageString:[yaml objectForKey:@"date"]];
        layout = [yaml objectForKey:@"layout"];
        permalink = [yaml objectForKey:@"permalink"];
        published = [(NSString *) [yaml objectForKey:@"published"] compare:@"true"] == NSOrderedSame;
        categories = [yaml objectForKey:@"categories"]; // TODO: Also support "category"
        tags = [yaml objectForKey:@"tags"];
        
        if (!categories) {
            categories = [NSMutableArray array];
        } else {
            [categories enumerateObjectsUsingBlock:^(NSString *tag, NSUInteger i, BOOL *stop) {
                categories[i] = [[DHLTag alloc] initWithName:tag];
            }];
        }
        
        if (!tags) {
            tags = [NSMutableArray array];
        }
    }
    
    return self;
}

- (void)openEditor {
    [[NSWorkspace sharedWorkspace] openURL:path];
}

- (void)showInFinder {
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[path]];
}

- (void)deletePost:(NSError **)error {
    [[NSFileManager defaultManager] removeItemAtURL:path error:error];
}

@end
