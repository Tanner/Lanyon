//
//  DHLPostTableCellView.h
//  Lanyon
//
//  Created by Tanner Smith on 1/2/14.
//  Copyright (c) 2014 Tanner Smith. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DHLPostTableCellView : NSTableCellView

@property (assign) IBOutlet NSTextField *title;
@property (assign) IBOutlet NSTextField *contents;
@property (assign) IBOutlet NSTextField *date;

@end
