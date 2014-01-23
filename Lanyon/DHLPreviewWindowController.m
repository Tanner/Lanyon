//
//  DHLPreviewSheetViewController.m
//  Lanyon
//
//  Created by Tanner Smith on 1/22/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import "DHLPreviewWindowController.h"

@implementation DHLPreviewWindowController

@synthesize progressIndicator;

- (void)windowDidLoad {
    [progressIndicator startAnimation:self];
}

@end
