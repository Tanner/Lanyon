//
//  DHLTag.m
//  Lanyon
//
//  Created by Tanner Smith on 2/9/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import "DHLTag.h"

@implementation DHLTag

@synthesize name;

- (id)initWithName:(NSString *)aName {
    if (self = [super init]) {
        name = aName;
    }
    
    return self;
}

@end
