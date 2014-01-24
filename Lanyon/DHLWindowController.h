//
//  DHLWindowController.h
//  Lanyon
//
//  Created by Tanner Smith on 1/2/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DHLPreviewWindowController.h"
#import "DHLPostsTableViewController.h"

@interface DHLWindowController : NSWindowController <NSTextFieldDelegate, NSToolbarDelegate>

@property (assign) BOOL creation;

@property (assign) IBOutlet NSWindow *creationSheet;
@property (assign) IBOutlet NSTextField *creationSheetPath;
@property (assign) IBOutlet NSButton *creationSheetCreateButton;

@property (assign) IBOutlet DHLPostsTableViewController *postsTableViewController;
@property (nonatomic, retain) DHLPreviewWindowController *previewWindowController;

@property (assign) IBOutlet NSView *postsView;

@property (assign) IBOutlet NSTextField *postCount;

- (IBAction)creationSheetChoosePath:(id)sender;
- (IBAction)creationSheetCancel:(id)sender;
- (IBAction)creationSheetCreate:(id)sender;

- (void)previewStopped;
- (void)previewStarting;
- (void)previewStarted;
- (void)previewFailed;

@end
