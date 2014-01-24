//
//  DHLWindowController.m
//  Lanyon
//
//  Created by Tanner Smith on 1/2/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import "DHLWindowController.h"

#import "DHLDocument.h"
#import "DHLPost.h"

#import "DHLPostTableCellView.h"

static NSString *DHLNewPostToolbarItemIdentifier = @"LanyonToolbarNewPostItem";
static NSString *DHLPreviewToolbarItemIdentifier = @"LanyonToolbarPreviewItem";

@implementation DHLWindowController

@synthesize creation, creationSheet, creationSheetPath, creationSheetCreateButton;
@synthesize postsTableViewController, previewWindowController;
@synthesize postCount;

@synthesize postsView;

- (id)init {
    if (self = [super initWithWindowNibName:@"DHLWindowController"]) {
        creation = NO;
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    if (creation) {
        [self showCreationSheet];
    }
    
    DHLJekyll *jekyll = [(DHLDocument *)[self document] jekyll];
    
    NSUInteger numberOfPosts = 0;
    
    if (jekyll) {
        numberOfPosts = [[jekyll posts] count];
    }
    
    postCount.stringValue = [NSString stringWithFormat:@"%ld Posts", (unsigned long)numberOfPosts];
    
    [self addToolbar];
    
    postsTableViewController.document = [self document];
    
    NSDictionary *viewsDictionary = @{
                                      @"postsView": postsView,
                                      @"postsTableView": postsTableViewController.view
                                      };
    
    [postsView addSubview:postsTableViewController.view];
    
    [postsTableViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [postsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[postsTableView]|"
                                                                      options:0 metrics:nil views:viewsDictionary]];
    [postsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[postsTableView]|"
                                                                      options:0 metrics:nil views:viewsDictionary]];
}

- (void)addToolbar {
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"DocumentToolbar"];
    
    [toolbar setAllowsUserCustomization:YES];
    [toolbar setAutosavesConfiguration:YES];
    [toolbar setDisplayMode:NSToolbarDisplayModeIconOnly];
    
    [toolbar setDelegate:self];
    
    [[self window] setToolbar:toolbar];
}

#pragma mark -
#pragma mark Creation Sheet

- (void)showCreationSheet {
    if (!creationSheet) {
        [[NSBundle mainBundle] loadNibNamed:@"DHLCreationSheet" owner:self topLevelObjects:nil];
    }
    
    [[self window] beginSheet:creationSheet completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSModalResponseOK) {
            DHLDocument *document = (DHLDocument *)self.document;
            DHLJekyll *jekyll = [[DHLJekyll alloc] initWithPath:[creationSheetPath stringValue]];
            
            [document setJekyll:jekyll];
            [postsTableViewController.postsTableView reloadData];
        } else {
            [[self document] close];
        }
        
        creationSheet = nil;
    }];
}

- (IBAction)creationSheetChoosePath:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    
    openPanel.canChooseFiles = NO;
    openPanel.canChooseDirectories = YES;
    openPanel.canCreateDirectories = NO;
    
    [openPanel beginSheetModalForWindow:creationSheet completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            [creationSheetPath setStringValue:[[openPanel URL] path]];
            
            [self checkValidCreation];
        }
    }];
}

- (IBAction)creationSheetCancel:(id)sender {
    [[self window] endSheet:creationSheet returnCode:NSModalResponseCancel];
}

- (IBAction)creationSheetCreate:(id)sender {
    [[self window] endSheet:creationSheet returnCode:NSModalResponseOK];
}

- (void)controlTextDidChange:(NSNotification *)obj {
    [self checkValidCreation];
}

- (void)checkValidCreation {
    if ([[creationSheetPath stringValue] length] > 0) {
        [creationSheetCreateButton setEnabled:YES];
    } else {
        [creationSheetCreateButton setEnabled:NO];
    }
}

#pragma mark -
#pragma mark Preview Sheet

- (void)showPreviewSheet {
    if (!previewWindowController) {
        previewWindowController = [[DHLPreviewWindowController alloc] initWithWindowNibName:@"DHLPreviewSheet"];        
    }
    
    [[self window] beginSheet:previewWindowController.window completionHandler:nil];
}

#pragma mark -
#pragma mark Toolbar Delegate

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return @[DHLNewPostToolbarItemIdentifier,
             DHLPreviewToolbarItemIdentifier,
             NSToolbarFlexibleSpaceItemIdentifier,
             NSToolbarSpaceItemIdentifier];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return @[DHLNewPostToolbarItemIdentifier,
             NSToolbarFlexibleSpaceItemIdentifier,
             DHLPreviewToolbarItemIdentifier];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    NSToolbarItem *toolbarItem;
    NSButton *button = [[NSButton alloc] init];
    
    [button setBezelStyle:NSTexturedRoundedBezelStyle];
    
    if ([itemIdentifier isEqualToString:DHLNewPostToolbarItemIdentifier]) {
        toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        
        [toolbarItem setLabel:@"New Post"];
        [toolbarItem setPaletteLabel:[toolbarItem label]];
        [toolbarItem setToolTip:@"Create a new post"];
        [toolbarItem setTarget:self];
        
        [button setImage:[NSImage imageNamed:NSImageNameAddTemplate]];
        
        [toolbarItem setMaxSize:NSMakeSize(40, 35)];
        [toolbarItem setMinSize:NSMakeSize(40, 35)];
    } else if ([itemIdentifier isEqualToString:DHLPreviewToolbarItemIdentifier]) {
        toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        
        [toolbarItem setLabel:@"Preview"];
        [toolbarItem setPaletteLabel:[toolbarItem label]];
        [toolbarItem setToolTip:@"Preview your site"];
        
        [button setButtonType:NSToggleButton];
        [button setTitle:@"Preview"];
        [button sizeToFit];
        
        [toolbarItem setMaxSize:[button frame].size];
        [toolbarItem setMinSize:[button frame].size];
        
        [button setTarget:self];
        [button setAction:@selector(previewButtonPushed)];
    }
    
    [toolbarItem setView:button];
    [toolbarItem setMenuFormRepresentation:[[NSMenuItem alloc] initWithTitle:[toolbarItem label] action:nil keyEquivalent:@""]];
    
    return toolbarItem;
}

- (void)previewButtonPushed {
    [[self document] previewJekyll];
}

#pragma mark -
#pragma mark Preview Methods
- (void)previewStopped {
    [[self window] endSheet:previewWindowController.window];
    [previewWindowController.window orderOut:self];
}

- (void)previewStarting {
    [self showPreviewSheet];
}

- (void)previewStarted {
    [[self window] endSheet:previewWindowController.window];
    [previewWindowController.window orderOut:self];
}

- (void)previewFailed {
    [self previewStopped];
    
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:@"Site preview failed."];
    [alert setInformativeText:@"Jekyll was unable to generate and show you the preview."];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    [alert beginSheetModalForWindow:[self window] completionHandler:nil];
}

@end
