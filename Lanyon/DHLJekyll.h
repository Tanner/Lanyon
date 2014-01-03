//
//  DHLJekyll.h
//  Lanyon
//
//  Created by Tanner Smith on 1/2/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHLJekyll : NSObject <NSCoding>

@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *title;

@property (nonatomic, retain) NSMutableArray *posts;

@property (nonatomic, retain) NSTask *previewTask;

@property (nonatomic, retain) dispatch_queue_t jekyllQueue;

- (void)loadPosts;

- (void)preview;

@end
