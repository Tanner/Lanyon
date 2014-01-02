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

#pragma mark -
#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        path = [aDecoder valueForKey:@"path"];
        title = [aDecoder valueForKey:@"title"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder setValue:path forKey:@"path"];
    [aCoder setValue:title forKey:@"title"];
}

@end
