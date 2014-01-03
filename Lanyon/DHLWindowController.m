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

@interface DHLWindowController ()

@end

@implementation DHLWindowController

@synthesize creation, creationSheet, creationSheetPath, creationSheetTitle, creationSheetCreateButton;

- (id)init {
    if (self = [super initWithWindowNibName:@"DHLWindowController"]) {
        creation = NO;
    }
    
    return self;
}

#pragma mark -
#pragma mark Creation Sheet

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    if (creation) {
        [self showCreationSheet];
    }
}

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

- (DHLPost *)postForRow:(NSInteger)row {
    DHLDocument *document = (DHLDocument *)self.document;
    DHLJekyll *jekyll = [document jekyll];
    
    return [[jekyll posts] objectAtIndex:row];
}

@end
