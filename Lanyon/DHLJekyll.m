//
//  DHLJekyll.m
//  Lanyon
//
//  Created by Tanner Smith on 1/2/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import "DHLJekyll.h"

#import "DHLPost.h"

@implementation DHLJekyll

@synthesize path, title;
@synthesize posts;

- (void)loadPosts {
    if (!posts) {
        NSString *postsDirectory = [path stringByAppendingPathComponent:@"_posts"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL directory;
        
        if ([fileManager fileExistsAtPath:postsDirectory isDirectory:&directory]) {
            NSError *error;
            
            NSArray *postFiles = (NSMutableArray *) [fileManager contentsOfDirectoryAtURL:[NSURL URLWithString:postsDirectory]
                       includingPropertiesForKeys:@[]
                                          options:NSDirectoryEnumerationSkipsHiddenFiles
                                            error:&error];
            
            posts = [[NSMutableArray alloc] init];
            
            [postFiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString *postPath = (NSString *) obj;
                
                [posts addObject:[[DHLPost alloc] initWithPath:postPath]];
            }];
        }
    }
}

#pragma mark -
#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        path = [aDecoder decodeObjectForKey:@"path"];
        title = [aDecoder decodeObjectForKey:@"title"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:path forKey:@"path"];
    [aCoder encodeObject:title forKey:@"title"];
}

@end
