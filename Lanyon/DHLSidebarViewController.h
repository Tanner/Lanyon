//
//  DHLSidebarViewController.h
//  Lanyon
//
//  Created by Tanner Smith on 1/26/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DHLDocument.h"
#import "DHLPostSelecting.h"

@interface DHLSidebarViewController : NSViewController <DHLPostSelecting>

@property (assign) DHLDocument *document;

@property (assign) NSTableView *tableView;
@property (nonatomic, retain) DHLPost *selectedPost;

@property (assign) IBOutlet NSArrayController *categoriesArrayController;
@property (assign) IBOutlet NSTableView *categoriesTableView;

- (IBAction)categorySegmentedControllerClicked:(id)sender;

- (void)addCategory;
- (void)removeSelectedCategory;

@end
