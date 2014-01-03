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

@synthesize postsTableView;
@synthesize creation, creationSheet, creationSheetPath, creationSheetTitle, creationSheetCreateButton;
@synthesize postCount;

- (id)init {
    if (self = [super initWithWindowNibName:@"DHLWindowController"]) {
        creation = NO;
    }
    
    return self;
}

- (void)awakeFromNib {
    [postsTableView setTarget:self];
    [postsTableView setDoubleAction:@selector(tableViewClicked)];
    
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"DocumentToolbar"];
    
    [toolbar setAllowsUserCustomization:YES];
    [toolbar setAutosavesConfiguration:YES];
    [toolbar setDisplayMode:NSToolbarDisplayModeIconOnly];
    
    [toolbar setDelegate:self];
    
    [[self window] setToolbar:toolbar];
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
        [jekyll loadPosts];

        numberOfPosts = [[jekyll posts] count];
    }
    
    postCount.stringValue = [NSString stringWithFormat:@"%ld Posts", (unsigned long)numberOfPosts];
}

#pragma mark -
#pragma mark Creation Sheet

- (void)showCreationSheet {
    if (!creationSheet) {
        [[NSBundle mainBundle] loadNibNamed:@"DHLCreationSheet" owner:self topLevelObjects:nil];
    }
    
    [creationSheetTitle setDelegate:self];
    
    [[self window] beginSheet:creationSheet completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSModalResponseOK) {
            DHLDocument *document = (DHLDocument *)self.document;
            DHLJekyll *jekyll = [[DHLJekyll alloc] init];
            
            [jekyll setPath:[creationSheetPath stringValue]];
            [jekyll setTitle:[creationSheetTitle stringValue]];
            
            [document setJekyll:jekyll];
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
    if ([[creationSheetPath stringValue] length] > 0 && [[creationSheetTitle stringValue] length] > 0) {
        [creationSheetCreateButton setEnabled:YES];
    } else {
        [creationSheetCreateButton setEnabled:NO];
    }
}

#pragma mark -
#pragma mark Table View Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    DHLDocument *document = (DHLDocument *)self.document;
    DHLJekyll *jekyll = [document jekyll];
    NSArray *posts = [jekyll posts];
    
    if (!posts) {
        [jekyll loadPosts];
    }
    
    return [[jekyll posts] count];
}

#pragma mark -
#pragma mark Table View Delegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    DHLPost *post = [self postForRow:row];
    
    DHLPostTableCellView *cellView = [tableView makeViewWithIdentifier:@"PostCell" owner:self];
    
    cellView.title.stringValue = [post.parsedYAML objectForKey:@"title"];
    cellView.contents.stringValue = post.text;
    cellView.date.stringValue = [post.parsedYAML objectForKey:@"date"];
    
    return cellView;
}

- (void)tableViewClicked {
    NSInteger row = [postsTableView clickedRow];
    DHLPost *post = [self postForRow:row];
    
    [[NSWorkspace sharedWorkspace] openURL:[post path]];
}

- (DHLPost *)postForRow:(NSInteger)row {
    DHLDocument *document = (DHLDocument *)self.document;
    DHLJekyll *jekyll = [document jekyll];
    
    return [[jekyll posts] objectAtIndex:row];
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
    NSSize itemSize;
    
    [button setBezelStyle:NSTexturedRoundedBezelStyle];
    
    if ([itemIdentifier isEqualToString:DHLNewPostToolbarItemIdentifier]) {
        toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        
        [toolbarItem setLabel:@"New Post"];
        [toolbarItem setPaletteLabel:[toolbarItem label]];
        [toolbarItem setToolTip:@"Create a new post"];
        [toolbarItem setTarget:self];
        
        [button setImage:[NSImage imageNamed:NSImageNameAddTemplate]];
        itemSize = NSMakeSize(40, 35);
    } else if ([itemIdentifier isEqualToString:DHLPreviewToolbarItemIdentifier]) {
        toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        
        [toolbarItem setLabel:@"Preview"];
        [toolbarItem setPaletteLabel:[toolbarItem label]];
        [toolbarItem setToolTip:@"Preview your site"];
        [toolbarItem setTarget:self];
        
        [button setImage:[NSImage imageNamed:NSImageNameQuickLookTemplate]];
        itemSize = NSMakeSize(50, 35);
    }
    
    [toolbarItem setView:button];
    [toolbarItem setMenuFormRepresentation:[[NSMenuItem alloc] initWithTitle:[toolbarItem label] action:nil keyEquivalent:@""]];
    [toolbarItem setMaxSize:itemSize];
    [toolbarItem setMinSize:itemSize];
    
    return toolbarItem;
}

@end
