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

- (id)initWithPath:(NSString *)aPath;

@end
