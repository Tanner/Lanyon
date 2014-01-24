//
//  DHLWindowController.h
//  Lanyon
//
//  Created by Tanner Smith on 1/2/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DHLPreviewWindowController.h"

@interface DHLWindowController : NSWindowController <NSTextFieldDelegate, NSTableViewDataSource, NSTableViewDelegate, NSToolbarDelegate>

@property (assign) BOOL creation;

@property (assign) IBOutlet NSWindow *creationSheet;
@property (assign) IBOutlet NSTextField *creationSheetPath;
@property (assign) IBOutlet NSButton *creationSheetCreateButton;

@property (nonatomic, retain) DHLPreviewWindowController *previewWindowController;

@property (assign) IBOutlet NSTableView *postsTableView;

@property (assign) IBOutlet NSTextField *postCount;

- (IBAction)creationSheetChoosePath:(id)sender;
- (IBAction)creationSheetCancel:(id)sender;
- (IBAction)creationSheetCreate:(id)sender;

- (IBAction)contextMenuOpen:(id)sender;
- (IBAction)contextMenuViewBrowser:(id)sender;
- (IBAction)contextMenuShowFinder:(id)sender;
- (IBAction)contextMenuDelete:(id)sender;

- (void)previewStopped;
- (void)previewStarting;
- (void)previewStarted;
- (void)previewFailed;

@end
