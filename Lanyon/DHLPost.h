//
//  DHLPost.h
//  Lanyon
//
//  Created by Tanner Smith on 1/2/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHLPost : NSObject

@property (nonatomic, retain) NSURL *path;
@property (nonatomic, retain) NSString *contents;

@property (nonatomic, retain) NSDictionary *yaml;
@property (nonatomic, retain) NSString *text;

// Common front matter
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *layout;
@property (nonatomic, retain) NSString *permalink;
@property (nonatomic, assign, getter = isPublished) BOOL published;
@property (nonatomic, retain) NSMutableArray *categories;
@property (nonatomic, retain) NSMutableArray *tags;

- (id)initWithPath:(NSURL *)aPath;

- (void)openEditor;
- (void)showInFinder;
- (void)deletePost:(NSError **)error;

@end
