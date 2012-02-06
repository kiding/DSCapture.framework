#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize imageView = _imageView;
@synthesize cgCheckBox = _cgCheckBox;

- (IBAction)captureFullAction:(id)sender
{
    [[[DSCapture sharedCapture] full] captureWithTarget:self selector:@selector(displayCaptureData:) useCG:[_cgCheckBox state]];
}

- (IBAction)captureSelectionAction:(id)sender
{
    [[[DSCapture sharedCapture] selection] captureWithTarget:self selector:@selector(displayCaptureData:) useCG:[_cgCheckBox state]];
}

- (void)displayCaptureData: (DSCaptureData *) sender
{
    [_imageView setImage:[sender imageAtIndex:([sender count]-1)]];
}

- (void)dealloc
{
    [super dealloc];
}

@end
