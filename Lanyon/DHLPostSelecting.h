//
//  DHLPostSelecting.h
//  Lanyon
//
//  Created by Tanner Smith on 1/29/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DHLPost.h"

@protocol DHLPostSelecting <NSObject>

- (void)postSelectionDidChange:(DHLPost *)post;

@end
