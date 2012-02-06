#import "DSCapture.h"
#import "DSCaptureFullController.h"
#import "DSCaptureSelectionController.h"

static DSCapture *sharedCapture = nil;

@implementation DSCapture

+ (DSCapture *) sharedCapture
{
    if(!sharedCapture)
        sharedCapture = [[DSCapture alloc] init];
    
    return sharedCapture;
}

- (id) init
{
    self = [super init];
    if(self) {
        full = nil;
        selection = nil;
    }
    return self;
}

- (DSCaptureFullController *) full
{
    if(full)
        [full release];
    
    full = [[DSCaptureFullController alloc] init];
    
    return full;
}

- (DSCaptureSelectionController *) selection
{
    if(selection)
        [selection release];
    
    selection = [[DSCaptureSelectionController alloc] init];
    
    return selection;
}

- (void) dealloc
{
    if(full)
        [full release];
    
    if(selection)
        [selection release];
    
    [super dealloc];
}

@end
