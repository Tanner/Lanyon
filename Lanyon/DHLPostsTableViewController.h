//
//  DHLPostsTableViewController.h
//  Lanyon
//
//  Created by Tanner Smith on 1/24/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DHLDocument.h"
#import "DHLPostSelecting.h"

@interface DHLPostsTableViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (assign) IBOutlet NSTableView *postsTableView;

@property (assign) id <DHLPostSelecting> delegate;
@property (assign) DHLDocument *document;

- (IBAction)contextMenuOpen:(id)sender;
- (IBAction)contextMenuViewBrowser:(id)sender;
- (IBAction)contextMenuShowFinder:(id)sender;
- (IBAction)contextMenuDelete:(id)sender;

@end
