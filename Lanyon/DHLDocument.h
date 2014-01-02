//
//  DHLDocument.h
//  Lanyon
//
//  Created by Tanner Smith on 1/2/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DHLJekyll.h"

@interface DHLDocument : NSDocument

@property (nonatomic, retain) DHLJekyll *jekyll;

@end
