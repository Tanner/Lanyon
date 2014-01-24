//
//  DHLPostsTableViewController.m
//  Lanyon
//
//  Created by Tanner Smith on 1/24/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import "DHLPostsTableViewController.h"

#import "DHLPost.h"
#import "DHLDocument.h"
#import "DHLJekyll.h"
#import "DHLPostTableCellView.h"

@implementation DHLPostsTableViewController

@synthesize postsTableView;
@synthesize document;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib {
    [postsTableView setTarget:self];
    [postsTableView setDoubleAction:@selector(tableViewClicked)];
    
    [postsTableView setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
}

#pragma mark -
#pragma mark Table View Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
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
    [self openEditorForSelectedPost];
}

- (void)openEditorForSelectedPost {
    [[self postForRow:[postsTableView clickedRow]] openEditor];
}

- (void)openFinderForSelectedPost {
    [[self postForRow:[postsTableView clickedRow]] showInFinder];
}

- (void)deleteSelectedPost {
    NSError *error;
    
    [[self postForRow:[postsTableView clickedRow]] deletePost:&error];
    
    if (error) {
        NSAlert *alert = [[NSAlert alloc] init];
        
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"Unable to delete post."];
        [alert setInformativeText:@"Lanyon was unable to delete the selected post."];
        [alert setAlertStyle:NSWarningAlertStyle];
        
        [alert beginSheetModalForWindow:[[self view] window] completionHandler:nil];
    }
}

- (DHLPost *)postForRow:(NSInteger)row {
    if (row < 0) {
        return nil;
    }
    
    DHLJekyll *jekyll = [document jekyll];
    
    return [[jekyll posts] objectAtIndex:row];
}

#pragma mark -
#pragma mark Table View Context Menu

- (IBAction)contextMenuOpen:(id)sender {
    [self openEditorForSelectedPost];
}

- (IBAction)contextMenuViewBrowser:(id)sender {
    // TODO: Implement me!
}

- (IBAction)contextMenuShowFinder:(id)sender {
    [self openFinderForSelectedPost];
}

- (IBAction)contextMenuDelete:(id)sender {
    [self deleteSelectedPost];
}

@end
