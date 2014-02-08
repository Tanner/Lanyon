//
//  DHLSidebarViewController.m
//  Lanyon
//
//  Created by Tanner Smith on 1/26/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import "DHLSidebarViewController.h"

@implementation DHLSidebarViewController

@synthesize document, tableView, selectedPost;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)postSelectionDidChange:(DHLPost *)post {
    [self setSelectedPost:post];
}

@end
