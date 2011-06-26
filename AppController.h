//
//  AppController.h
//  DeskTime
//
//  Created by Hunter on 4/9/11.
//  Copyright 2011 Studio182. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject {

	NSString *name;
    NSString *morningwall;
    NSString *noonwall;
    NSString *nightwall;
    NSString *appsupportpath;
    NSString *openpurchase;
    NSString *openlicense;
	IBOutlet NSTextView *textView;
    IBOutlet NSImageView *morningcell;
    IBOutlet NSImageView *nooncell;
    IBOutlet NSImageView *nightcell;
    NSWindow *enterlicensewindow;
    NSWindow *expiredwindow;
    NSWindow *notactivatedwindow;
    NSWindow *agreewindow;
    IBOutlet NSMenu *statusMenu;    
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusHighlightImage;
    NSString *activated;
    NSString *licensefancy;
    NSString *status;
    NSString *updatetime;
    NSTimer *timer;
    NSString *agreed;
}

@property (copy) NSString *name;
- (NSString *)checkLicense:(NSString *)license;
- (IBAction)validate:(id)sender;


@property (copy) NSString *activated;
- (NSString *)checkLicenseRaw:(NSString *)license;

@property (copy) NSString *agreed;
- (IBAction)agree:(id)sender;

@property (copy) NSString *licensefancy;
- (NSString *)checkLicenseFancy:(NSString *)license;

@property (copy) NSString *updatetime;
- (IBAction)update_times;

@property (copy) NSString *openpurchase;
- (IBAction)openpurchaseaction:(id)sender;

@property (copy) NSString *openlicense;
- (IBAction)openlicenseaction:(id)sender;

@property (copy) NSString *morningwall;
- (NSString *)getmorningwall;

@property (copy) NSString *noonwall;
- (NSString *)getnoonwall;


@property (copy) NSString *nightwall;
- (NSString *)getnightwall;


@property (copy) NSString *appsupportpath;
- (NSString *)getappsupport;


@property (copy) NSString *status;
- (NSString *)checkstatus;



@property (copy) NSTimer *timer;

@property (assign) IBOutlet NSWindow *enterlicensewindow;
@property (assign) IBOutlet NSWindow *expiredwindow;
@property (assign) IBOutlet NSWindow *notactivatedwindow;
@property (assign) IBOutlet NSWindow *agreewindow;

@end
