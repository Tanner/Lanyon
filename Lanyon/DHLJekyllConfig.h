//
//  DHLJekyllConfig.h
//  Lanyon
//
//  Created by Tanner Smith on 1/23/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHLJekyllConfig : NSObject

@property (nonatomic, retain) NSString *path;

@property (nonatomic, retain) NSDictionary *contents;

- (id)initWithPath:(NSString *)aPath;

@end
