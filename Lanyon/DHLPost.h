//
//  DHLPost.h
//  Lanyon
//
//  Created by Tanner Smith on 1/2/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHLPost : NSObject

@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *contents;

@property (nonatomic, retain) NSString *yaml;
@property (nonatomic, retain) NSString *text;

@property (nonatomic, retain) NSDictionary *parsedYAML;

- (id)initWithPath:(NSString *)aPath;

@end
