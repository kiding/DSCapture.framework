#import "DSCaptureFullController.h"
#import "DSCaptureData.h"

@implementation DSCaptureFullController

- (id) init
{
    self = [super init];
    if(self) {
        callbackTarget = nil;
        callbackSelector = nil;
    }
    return self;
}

- (void) captureWithTarget: (id) target
                  selector: (SEL) selector
                     useCG: (BOOL) cg;
{
    if (target && selector) {
        callbackTarget = target;
        callbackSelector = selector;
    } else    
        return;

    if(cg)
        [self performSelectorInBackground:@selector(cgCapture) withObject:nil];
    else
        [self performSelectorInBackground:@selector(sysCapture) withObject:nil];
}

@end
