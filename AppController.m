//
//  AppController.m
//  DeskTime
//
//  Created by Hunter on 4/9/11.
//  Copyright 2011 Studio182. All rights reserved.
//

#import "AppController.h"
#import "AquaticPrime.h"
#import "NSData-AES.h"
#import "Base64.h"
#import "JSON.h"

@implementation AppController
@synthesize name;
@synthesize openpurchase;
@synthesize openlicense;
@synthesize morningwall;
@synthesize noonwall;
@synthesize nightwall;
@synthesize appsupportpath;
@synthesize enterlicensewindow;
@synthesize expiredwindow;
@synthesize notactivatedwindow;
@synthesize agreewindow;
@synthesize activated;
@synthesize licensefancy;
@synthesize status;
@synthesize updatetime;
@synthesize timer;
@synthesize agreed;

- (void)awakeFromNib
{    
    NSLog(@"DeskTime Starting...");
	[self setName:[self checkLicense:[textView string]]];
    [self setMorningwall:[self getmorningwall]];
    [self setNoonwall: [self getnoonwall]];
    [self setNightwall:[self getnightwall]];
    [self setAppsupportpath:[self getappsupport]];
    [self setActivated:[self checkLicenseRaw:[textView string]]];
    [self setLicensefancy:[self checkLicenseFancy:[textView string]]];
    [self setStatus:[self checkstatus]];
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
    NSBundle *bundle = [NSBundle mainBundle];
    statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"desktime-clock" ofType:@"png"]];
    statusHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"desktime-clock-selected" ofType:@"png"]];
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:statusHighlightImage];
    [statusItem setMenu:statusMenu];
    [statusItem setToolTip:@"DeskTime"];
    [statusItem setHighlightMode:YES];    
    NSLog(@"Activation Status: %@",activated);
   // [self update_times];
    
    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(mainLoop:) userInfo:nil repeats:YES];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"init"] == 1){
    
    if(licensefancy == @"expired") {
        [expiredwindow orderFront:expiredwindow];
        NSLog(@"Expired");
    } 
    else if (licensefancy == @"true"){
        NSLog(@"Registered");
        timer;
        [self wallpaper];
    } else {
        
        NSLog(@"NOT ACTIVATED!");
        [notactivatedwindow orderFront:notactivatedwindow];
    }
    } else {
    [agreewindow makeKeyAndOrderFront:agreewindow];
    }
    
}

- (IBAction)agree:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"init"];
    [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"enabled"];
    [agreewindow performClose:enterlicensewindow];
    [enterlicensewindow orderFront:enterlicensewindow];
}

- (void)mainLoop:(NSTimer *)timer
{
        [self wallpaper];
}

- (IBAction)validate:(id)sender
{
	NSUserDefaultsController *defaultsController = [NSUserDefaultsController sharedUserDefaultsController];
	[defaultsController save:sender];	
	[self setName:[self checkLicense:[textView string]]];
}

- (IBAction)openpurchaseaction:(id)sender
{      
    if( [notactivatedwindow isVisible] ) {
    [notactivatedwindow performClose:expiredwindow];
    } else if( [expiredwindow isVisible] ) {
        [expiredwindow performClose:expiredwindow];
    }

    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://secure.madebyhd.us/#!/desktime/purchase"]];
if(! [enterlicensewindow isVisible] ) {
    [enterlicensewindow deminiaturize:sender];
    } else {
        [enterlicensewindow orderFront:enterlicensewindow];
    }
}

- (IBAction)openlicenseaction:(id)sender
{
    if( [notactivatedwindow isVisible] ) {
        [notactivatedwindow performClose:expiredwindow];
    } else if( [expiredwindow isVisible] ) {
        [expiredwindow performClose:expiredwindow];
    }
    if(! [enterlicensewindow isVisible] ) {
        [enterlicensewindow deminiaturize:sender];
    } else {
        [enterlicensewindow orderFront:enterlicensewindow];
    }
}

- (NSString *)getappsupport {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *folder = @"~/Library/Application Support/DeskTime/";
    folder = [folder stringByExpandingTildeInPath];

    if ([fileManager fileExistsAtPath: folder] == NO)
    {
        NSLog(@"Detected: Missing or Corrupted App Support Folder... its okay, Creating it");
        [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"Finished Creating App Support folder");
    }
    return folder;   
}

- (NSString *)checkstatus {
    NSUserDefaults *defaults;
    BOOL enabled;
    defaults = [NSUserDefaults standardUserDefaults];
    enabled = [defaults boolForKey:@"enable"];
    //NSLog(@"Disktime is good: %@",enabled);
    return @"true";
}

//Morning Copy

-(IBAction)copymorning:(id)sender {
    NSImage *image = [morningcell image];
    NSData *imageData = [image  TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.9] forKey:NSImageCompressionFactor];
     imageData = [imageRep representationUsingType:NSTIFFFileType properties:imageProps];
    NSLog(@"Starting Morning Copy");
    [imageData writeToFile:[appsupportpath stringByAppendingPathComponent: @"morning.tiff"] atomically:NO]; 
    NSLog(@"Ending Morning Copy");
    [self wallpaper];
}

//Noon Copy

-(IBAction)copynoon:(id)sender {
    NSImage *image = [nooncell image];
    NSData *imageData = [image  TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.9] forKey:NSImageCompressionFactor];
    imageData = [imageRep representationUsingType:NSTIFFFileType properties:imageProps];
    NSLog(@"Starting Noon Copy");
    [imageData writeToFile:[appsupportpath stringByAppendingPathComponent: @"noon.tiff"] atomically:NO]; 
    NSLog(@"Ending Noon Copy");
    [self wallpaper];
}


//Night Copy

-(IBAction)copynight:(id)sender {
    NSImage *image = [nightcell image];
    NSData *imageData = [image  TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.9] forKey:NSImageCompressionFactor];
    imageData = [imageRep representationUsingType:NSTIFFFileType properties:imageProps];
    NSLog(@"Starting Night Copy");
    [imageData writeToFile:[appsupportpath stringByAppendingPathComponent: @"night.tiff"] atomically:NO]; 
    NSLog(@"Ending Night Copy");    
    [self wallpaper];
}

-(IBAction)update_times {
/*    NSString *zip = @"61377";
    NSMutableString *woeidurl = [NSMutableString string];
	[woeidurl appendString:@"http://query.yahooapis.com/v1/public/yql?q=select%20astronomy%20from%20weather.forecast%20where%20location%3D"];
    [woeidurl appendString:zip];
    [woeidurl appendString:@"&format=json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:woeidurl]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSArray *json = [json_string JSONValue];
*/
}
 
- (NSString *)getmorningwall
{
    NSString *user = NSUserName();
    NSString *home = NSHomeDirectoryForUser(user);
    NSMutableString *prefs = [NSMutableString string];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableString *filepath = [NSMutableString string];
        NSString *file;
    [filepath appendString:home];
    [filepath appendString:@"/Library/Application Support/DeskTime/morning.tiff"];
    file = [filepath stringByExpandingTildeInPath];
    if ([fileManager fileExistsAtPath: file] == YES)
    {
        NSLog(@"Morning Wallpaper Exists... using that!");
        return filepath;
    } else {
        NSLog(@"Morning Wallpaper Doesn't Exists... using system!");
        [prefs appendString:home];
        [prefs appendString:@"/Library/Preferences/com.apple.desktop.plist"];
        NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:prefs];
        NSString *item = [plistData valueForKeyPath:@"Background.default.NewImageFilePath"];
        return item;
    }
}

- (NSString *)getnoonwall
{
    NSString *user = NSUserName();
    NSString *home = NSHomeDirectoryForUser(user);
    NSMutableString *prefs = [NSMutableString string];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableString *filepath = [NSMutableString string];
    NSString *file;
    [filepath appendString:home];
    [filepath appendString:@"/Library/Application Support/DeskTime/noon.tiff"];
    file = [filepath stringByExpandingTildeInPath];
    if ([fileManager fileExistsAtPath: file] == YES)
    {
        NSLog(@"Noon Wallpaper Exists... using that!");
        return filepath;
    } else {
        NSLog(@"Noon Wallpaper Doesn't Exists... using system!");
        [prefs appendString:home];
        [prefs appendString:@"/Library/Preferences/com.apple.desktop.plist"];
        NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:prefs];
        NSString *item = [plistData valueForKeyPath:@"Background.default.NewImageFilePath"];
        return item;
    }
}

- (NSString *)getnightwall
{
    NSString *user = NSUserName();
    NSString *home = NSHomeDirectoryForUser(user);
    NSMutableString *prefs = [NSMutableString string];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableString *filepath = [NSMutableString string];
    NSString *file;
    [filepath appendString:home];
    [filepath appendString:@"/Library/Application Support/DeskTime/night.tiff"];
    file = [filepath stringByExpandingTildeInPath];
    if ([fileManager fileExistsAtPath: file] == YES)
    {
        NSLog(@"Night Wallpaper Exists... using that!");
        return filepath;
    } else {
        NSLog(@"Night Wallpaper Doesn't Exists... using system!");
        [prefs appendString:home];
        [prefs appendString:@"/Library/Preferences/com.apple.desktop.plist"];
        NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:prefs];
        NSString *item = [plistData valueForKeyPath:@"Background.default.NewImageFilePath"];
        return item;
    }
}
- (NSString *)checkLicenseFancy:(NSString *)license
{
	
	// This string is specially constructed to prevent key replacement 	// *** Begin Public Key ***
	NSMutableString *key = [NSMutableString string];
	[key appendString:@"0xE2D08694F7D80EA13D234593848C"];
	[key appendString:@"F36CB1C3BD79B51618C90D8BF73A3E"];
	[key appendString:@"9636"];
	[key appendString:@"C"];
	[key appendString:@"C"];
	[key appendString:@"BF450A803072BDAC48AC7AFB"];
	[key appendString:@""];
	[key appendString:@"2"];
	[key appendString:@"2"];
	[key appendString:@"5602D61065890EE76A978F224E4B"];
	[key appendString:@"5A3F8B6536DF0CDE"];
	[key appendString:@"2"];
	[key appendString:@"2"];
	[key appendString:@"BE35B762E478"];
	[key appendString:@"236D32CDF353150DF2624C2B1E12ED"];
	[key appendString:@"91680AF8C2E81C062EB5E8D6954F94"];
	[key appendString:@"61A48"];
	[key appendString:@"4"];
	[key appendString:@"4"];
	[key appendString:@"C7FCD530CEC54F37FBFF8AD"];
	[key appendString:@"A5B4F154173A7753FF"];
	// *** End Public Key *** 
	
	AquaticPrime *licenseValidator = [AquaticPrime aquaticPrimeWithKey:key];
	
    
	NSData	*b64 = [Base64 decode:license];	
	
	NSDictionary *licenseDictionary = [licenseValidator dictionaryForLicenseData:b64];
	
    if (licenseDictionary == nil) {
		return @"false";
	}
	else {
        return @"true";
    }
}

- (NSString *)checkLicenseRaw:(NSString *)license
{
	
	// This string is specially constructed to prevent key replacement 	// *** Begin Public Key ***
	NSMutableString *key = [NSMutableString string];
	[key appendString:@"0xE2D08694F7D80EA13D234593848C"];
	[key appendString:@"F36CB1C3BD79B51618C90D8BF73A3E"];
	[key appendString:@"9636"];
	[key appendString:@"C"];
	[key appendString:@"C"];
	[key appendString:@"BF450A803072BDAC48AC7AFB"];
	[key appendString:@""];
	[key appendString:@"2"];
	[key appendString:@"2"];
	[key appendString:@"5602D61065890EE76A978F224E4B"];
	[key appendString:@"5A3F8B6536DF0CDE"];
	[key appendString:@"2"];
	[key appendString:@"2"];
	[key appendString:@"BE35B762E478"];
	[key appendString:@"236D32CDF353150DF2624C2B1E12ED"];
	[key appendString:@"91680AF8C2E81C062EB5E8D6954F94"];
	[key appendString:@"61A48"];
	[key appendString:@"4"];
	[key appendString:@"4"];
	[key appendString:@"C7FCD530CEC54F37FBFF8AD"];
	[key appendString:@"A5B4F154173A7753FF"];
	// *** End Public Key *** 
	
	AquaticPrime *licenseValidator = [AquaticPrime aquaticPrimeWithKey:key];
	
    
	NSData	*b64 = [Base64 decode:license];	
	
	NSDictionary *licenseDictionary = [licenseValidator dictionaryForLicenseData:b64];
	
    if (licenseDictionary == nil) {
		return nil;
	}
	else {
        return @"true";
    }
}

- (NSString *)checkLicense:(NSString *)license
{
	
	// This string is specially constructed to prevent key replacement 	// *** Begin Public Key ***
	NSMutableString *key = [NSMutableString string];
	[key appendString:@"0xE2D08694F7D80EA13D234593848C"];
	[key appendString:@"F36CB1C3BD79B51618C90D8BF73A3E"];
	[key appendString:@"9636"];
	[key appendString:@"C"];
	[key appendString:@"C"];
	[key appendString:@"BF450A803072BDAC48AC7AFB"];
	[key appendString:@""];
	[key appendString:@"2"];
	[key appendString:@"2"];
	[key appendString:@"5602D61065890EE76A978F224E4B"];
	[key appendString:@"5A3F8B6536DF0CDE"];
	[key appendString:@"2"];
	[key appendString:@"2"];
	[key appendString:@"BE35B762E478"];
	[key appendString:@"236D32CDF353150DF2624C2B1E12ED"];
	[key appendString:@"91680AF8C2E81C062EB5E8D6954F94"];
	[key appendString:@"61A48"];
	[key appendString:@"4"];
	[key appendString:@"4"];
	[key appendString:@"C7FCD530CEC54F37FBFF8AD"];
	[key appendString:@"A5B4F154173A7753FF"];
	// *** End Public Key *** 
	
	AquaticPrime *licenseValidator = [AquaticPrime aquaticPrimeWithKey:key];
	
		
	NSData	*b64 = [Base64 decode:license];	
	
	NSDictionary *licenseDictionary = [licenseValidator dictionaryForLicenseData:b64];
	
   if (licenseDictionary == nil) {
       NSLog(@"Activation Status: %@",activated);
		return @"Not registered";
       //if (timer == nil) {} else {
       //}
	}
	else {
		NSMutableString *who = [NSMutableString string];
		[who appendString:[licenseDictionary objectForKey:@"Name"]];
		[who appendString:@" ("];
		[who appendString:[licenseDictionary objectForKey:@"Email"]];
		[who appendString:@")"];
        NSLog(@"Activation Status: %@",activated);
        return who;
	    }
}
- (void) dealloc {
    //Releases the 2 images we loaded into memory
    [statusImage release];
    [statusHighlightImage release];
    [super dealloc];
}

- (IBAction) wallpaper{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"enabled"] == 1){
    NSLog(@"Running Wallpaper Script");

    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
    
        NSString* urrenttime = [[NSDate  date]descriptionWithCalendarFormat:@"%H%M" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
        
        int curtime;
        curtime = [urrenttime intValue];
        
      //  NSInteger curtime = 1105;
        
        
        if (curtime >= 1900 && curtime <= 2400 || curtime >= 0 && curtime <= 459) {
            NSLog(@"It is Night");
        NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
                                   @"\
                                   set mainwall to \"~/Library/Application Support/DeskTime/night.tiff\"\n\
                                   try\n\
                                   --mainwall as alias\n\
                                   tell application \"System Events\"\n\
                                   tell every desktop\n\
                                   set picture rotation to 0\n\
                                   set picture to POSIX file mainwall\n\
                                   end tell\n\
                                   end tell\n\
                                   end try"];
            returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
            [scriptObject release];
        } else if (curtime >= 500 && curtime <= 1159) {
            NSLog(@"It is Morning");
            NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
                                           @"\
                                           set mainwall to \"~/Library/Application Support/DeskTime/morning.tiff\"\n\
                                           try\n\
                                           --mainwall as alias\n\
                                           tell application \"System Events\"\n\
                                           tell every desktop\n\
                                           set picture rotation to 0\n\
                                           set picture to POSIX file mainwall\n\
                                           end tell\n\
                                           end tell\n\
                                           end try"];
            returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
            [scriptObject release];
           
        } else if (curtime >= 1200 && curtime <= 1859) {
            NSLog(@"It is Noon");
            NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
                                           @"\
                                           set mainwall to \"~/Library/Application Support/DeskTime/noon.tiff\"\n\
                                           try\n\
                                           --mainwall as alias\n\
                                           tell application \"System Events\"\n\
                                           tell every desktop\n\
                                           set picture rotation to 0\n\
                                           set picture to POSIX file mainwall\n\
                                           end tell\n\
                                           end tell\n\
                                           end try"];
            returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
            [scriptObject release];

        } else {
            NSLog(@"It is Error");
        }
    
    if (returnDescriptor != NULL)
    {
        // successful execution
        if (kAENullEvent != [returnDescriptor descriptorType])
        {
            // script returned an AppleScript result
            if (cAEList == [returnDescriptor descriptorType])
            {
                // result is a list of other descriptors
            }
            else
            {
                // coerce the result to the appropriate ObjC type
            }
        } 
    }
    else
    {
        // no script result, handle error here
    }
    } else {
        NSLog(@"Ran loop, but desktime isn't enabled...");
    }
}

@end
