//
//  DeskTimeAppDelegate.h
//  DeskTime
//
//  Created by Hunter on 4/9/11.
//  Copyright 2011 Studio182. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DeskTimeAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
