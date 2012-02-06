#import "DSCaptureData.h"

@interface DSCaptureSelectionController : NSObject <NSWindowDelegate>
{
    id callbackTarget;
    SEL callbackSelector;
    
    // for CoreGraphics
    NSMutableArray *selectionWindowArray;
}

- (id) init;

- (void) captureWithTarget: (id) target
                  selector: (SEL) selector
                     useCG: (BOOL) cg;

@end
