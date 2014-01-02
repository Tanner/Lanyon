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

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    return [NSKeyedArchiver archivedDataWithRootObject:jekyll];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    jekyll = [NSUnarchiver unarchiveObjectWithData:data];
    
    return YES;
}

@end
