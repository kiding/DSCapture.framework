#import <Cocoa/Cocoa.h>
#import <DSCapture/DSCapture.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSImageView *imageView;
@property (assign) IBOutlet NSButton *cgCheckBox;

- (IBAction)captureFullAction:(id)sender;

- (IBAction)captureSelectionAction:(id)sender;

- (void)displayCaptureData: (NSData *) sender;

@end
