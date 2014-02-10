//
//  DHLSidebarViewController.m
//  Lanyon
//
//  Created by Tanner Smith on 1/26/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import "DHLSidebarViewController.h"

#import "DHLTag.h"

@implementation DHLSidebarViewController

@synthesize document, tableView, selectedPost, categoriesArrayController, categoriesTableView;

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

- (IBAction)categorySegmentedControllerClicked:(id)sender {
    NSInteger clickedSegment = [sender selectedSegment];
    
    switch (clickedSegment) {
        case 0:
            [self addCategory];
            break;
        case 1:
            [self removeSelectedCategory];
            break;
    }
}

- (void)addCategory {
    [categoriesArrayController addObject:[[DHLTag alloc] initWithName:@"New Tag"]];
}

- (void)removeSelectedCategory {
    NSInteger selectedRow = [categoriesTableView selectedRow];
    
    if (selectedRow != -1) {
        [categoriesArrayController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndex:selectedRow]];
    }
}

@end
