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
@synthesize config, posts;
@synthesize previewTask, jekyllQueue;

const NSString *rubyPath = @"/usr/local/Cellar/ruby/2.0.0-p247/bin";
const NSString *jekyllPath = @"/usr/local/Cellar/ruby/2.0.0-p247/bin";

const NSString *exportEncoding = @"export LANG=\"en_US.UTF-8\"; export LC_ALL=\"en_US.UTF-8\"";

- (id)initWithPath:(NSString *)aPath {
    if (self = [super init]) {
        jekyllQueue = dispatch_queue_create("me.tannersmith.lanyon.jekyll", NULL);
        
        path = aPath;
        config = [[DHLJekyllConfig alloc] initWithPath:path];
    }
    
    return self;
}

- (void)dealloc {
    [previewTask terminate];
}

- (NSArray *)posts {
    if (!posts) {
        NSString *postsDirectory = [path stringByAppendingPathComponent:@"_posts"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL directory;
        
        if ([fileManager fileExistsAtPath:postsDirectory isDirectory:&directory]) {
            NSError *error;
            
            NSURL *postsURL = [NSURL fileURLWithPath:postsDirectory];
            
            NSArray *postFiles = (NSMutableArray *) [fileManager contentsOfDirectoryAtURL:postsURL
                                                               includingPropertiesForKeys:@[]
                                                                                  options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                                    error:&error];
            
            NSMutableArray *tempPosts = [[NSMutableArray alloc] init];
            
            [postFiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSURL *postPath = (NSURL *) obj;
                
                [tempPosts addObject:[[DHLPost alloc] initWithPath:postPath]];
            }];
            
            self.posts = [NSArray arrayWithArray:tempPosts];
        }
    }
    
    return posts;
}

- (DHLJekyllConfig *)config {
    if (config == nil) {
        config = [[DHLJekyllConfig alloc] initWithPath:path];
    }
    
    return config;
}

- (NSString *)title {
    return [[[self config] contents] objectForKey:@"name"];
}

#pragma mark -
#pragma mark Preview - `jekyll serve`

- (void)startPreviewWithBlock:(void (^)(BOOL running))block {
    if (previewTask) {
        if ([previewTask isRunning]) {
            return;
        } else {
            previewTask = nil;
        }
    }
    
    previewTask = [[NSTask alloc] init];

    [previewTask setLaunchPath:@"/bin/bash"];
    [previewTask setCurrentDirectoryPath:path];

    NSString *exportPath = [NSString stringWithFormat:@"export PATH=%@:%@:$PATH", rubyPath, jekyllPath];
    NSString *command = [NSString stringWithFormat:@"%@; %@; %@", exportPath, exportEncoding, @"jekyll serve --watch --trace"];
    
    [previewTask setArguments:@[@"-c", command]];
        
    NSPipe *standardPipe = [NSPipe pipe];
    NSFileHandle *standardFileHandle = [standardPipe fileHandleForReading];
    
    [previewTask setStandardOutput:standardPipe];
    [previewTask launch];
    
    dispatch_async(jekyllQueue, ^{
        NSData *data = nil;
        NSMutableData *taskData = [NSMutableData data];
        
        BOOL running = NO;
        
        while ((data = [standardFileHandle availableData]) && [data length]) {
            [taskData appendData:data];
            
            NSString *output = [[NSString alloc] initWithData:taskData encoding:NSUTF8StringEncoding];
            
            if ([output rangeOfString:@"Server running"].location != NSNotFound) {
                running = YES;
                
                break;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(running);
        });
    });
}

- (void)stopPreview {
    if ([previewTask isRunning]) {
        [previewTask terminate];
        
        previewTask = nil;
    }
}

- (BOOL)isPreviewing {
    return [previewTask isRunning];
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
