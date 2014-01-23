//
//  DHLDocument.m
//  Lanyon
//
//  Created by Tanner Smith on 1/2/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import "DHLDocument.h"

#import "DHLWindowController.h"

@implementation DHLDocument

@synthesize jekyll;

- (id)init
{
    if (self = [super init]) {
        // Add your subclass-specific initialization here.
    }
    
    return self;
}

- (void)makeWindowControllers {
    if ([[self windowControllers] count] == 0) {
        [self addWindowController:[[DHLWindowController alloc] init]];
    }
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
}

- (NSString *)displayName {
    if (jekyll) {
        return [jekyll title];
    }

    return [super displayName];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (void)showWindows {
    [self makeWindowControllers];
    
    [[self windowController] setCreation:jekyll == nil];
    
    [super showWindows];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    return [NSKeyedArchiver archivedDataWithRootObject:jekyll];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    jekyll = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return YES;
}

- (void)close {
    [jekyll stopPreview];
}

- (DHLWindowController *)windowController {
    [self makeWindowControllers];
    
    return [[self windowControllers] objectAtIndex:0];
}

- (void)previewJekyll {
    if ([jekyll isPreviewing]) {
        [[self windowController] previewStopped];
        
        [jekyll stopPreview];
    } else {
        [[self windowController] previewStarting];
        
        [jekyll startPreviewWithBlock:^(BOOL running) {
            if (running) {
                [[self windowController] previewStarted];
                
                [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://0.0.0.0:4000"]];
            } else {
                [[self windowController] previewFailed];
            }
        }];
    }
}

@end
