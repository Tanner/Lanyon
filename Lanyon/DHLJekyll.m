//
//  DHLJekyll.m
//  Lanyon
//
//  Created by Tanner Smith on 1/2/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import "DHLJekyll.h"

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
            
            posts = (NSMutableArray *) [fileManager contentsOfDirectoryAtURL:[NSURL URLWithString:postsDirectory]
                       includingPropertiesForKeys:@[]
                                          options:NSDirectoryEnumerationSkipsHiddenFiles
                                            error:&error];
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
