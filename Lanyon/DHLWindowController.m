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
    
    [postsTableView setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
    
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
    
    return [[jekyll posts] count];
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors {
    DHLJekyll *jekyll = [[self document] jekyll];
    
    jekyll.posts = [[jekyll posts] sortedArrayUsingDescriptors:[tableView sortDescriptors]];
    
    [tableView reloadData];
}

#pragma mark -
#pragma mark Table View Delegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    DHLPost *post = [self postForRow:row];
    
    DHLPostTableCellView *cellView = [tableView makeViewWithIdentifier:@"PostCell" owner:self];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    cellView.title.stringValue = [post title];
    cellView.contents.stringValue = [post text];
    cellView.date.stringValue = [dateFormatter stringFromDate:[post date]];
    
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
        
        [toolbarItem setLabel:[self titleForPreviewButton]];
        [toolbarItem setPaletteLabel:[toolbarItem label]];
        [toolbarItem setToolTip:@"Preview your site"];
        
        [button setTitle:[self titleForPreviewButton]];
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
    
    [self updatePreviewButton];
}

- (void)updatePreviewButton {
    __block NSToolbarItem *buttonToolbarItem;
    
    [[[[self window] toolbar] items] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSToolbarItem *item = (NSToolbarItem *) obj;
        
        if ([[item itemIdentifier] isEqualToString:DHLPreviewToolbarItemIdentifier]) {
            buttonToolbarItem = item;
            
            *stop = YES;
        }
    }];
    
    NSButton *button = (NSButton *) [buttonToolbarItem view];
    
    [button setTitle:[self titleForPreviewButton]];
    [button sizeToFit];
    
    NSSize size = [button frame].size;
    
    [buttonToolbarItem setMaxSize:size];
    [buttonToolbarItem setMinSize:size];
}

- (NSString *)titleForPreviewButton {
    if ([[[self document] jekyll] isPreviewing]) {
        return @"Stop Previewing";
    } else {
        return @"Preview";
    }
}

- (void)failedToRun {
    [self updatePreviewButton];
    
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:@"Site preview failed."];
    [alert setInformativeText:@"Jekyll was unable to generate and show you the preview."];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    [alert beginSheetModalForWindow:[self window] completionHandler:nil];
}

@end
