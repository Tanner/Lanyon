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
@synthesize previewTask, jekyllQueue;

- (id)init {
    if (self = [super init]) {
        jekyllQueue = dispatch_queue_create("me.tannersmith.lanyon.jekyll", NULL);
    }
    
    return self;
}

- (void)dealloc {
    [previewTask terminate];
}

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
                NSURL *postPath = (NSURL *) obj;
                
                [posts addObject:[[DHLPost alloc] initWithPath:postPath]];
            }];
        }
    }
}

- (void)preview {
    if (!previewTask) {
        previewTask = [[NSTask alloc] init];

        [previewTask setLaunchPath:@"/bin/bash"];
        [previewTask setCurrentDirectoryPath:path];

        [previewTask setArguments:@[@"-c", @"jekyll serve --watch"]];
    }
    
    if ([previewTask isRunning]) {
        [previewTask terminate];
        
        previewTask = nil;
    } else {
        NSPipe *pipe = [NSPipe pipe];
        NSFileHandle *fileHandle = [pipe fileHandleForReading];

        [previewTask setStandardOutput:pipe];
        [previewTask launch];
        
        dispatch_async(jekyllQueue, ^{
            NSData *data = nil;
            NSMutableData *taskData = [NSMutableData data];
            
            while ((data = [fileHandle availableData]) && [data length]) {
                [taskData appendData:data];
                
                NSString *output = [[NSString alloc] initWithData:taskData encoding:NSUTF8StringEncoding];
                
                if ([output rangeOfString:@"Server running"].location != NSNotFound) {
                    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://0.0.0.0:4000"]];
                    break;
                }
            }
        });
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
