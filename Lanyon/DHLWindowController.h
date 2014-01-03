//
//  DHLWindowController.h
//  Lanyon
//
//  Created by Tanner Smith on 1/2/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DHLWindowController : NSWindowController <NSTextFieldDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (assign) BOOL creation;

@property (assign) IBOutlet NSWindow *creationSheet;
@property (assign) IBOutlet NSTextField *creationSheetPath;
@property (assign) IBOutlet NSTextField *creationSheetTitle;
@property (assign) IBOutlet NSButton *creationSheetCreateButton;

- (IBAction)creationSheetChoosePath:(id)sender;
- (IBAction)creationSheetCancel:(id)sender;
- (IBAction)creationSheetCreate:(id)sender;

@end
