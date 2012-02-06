#import "DSCaptureData.h"
#import "DSCaptureFullController.h"
#import "DSCaptureSelectionController.h"

@interface DSCapture : NSObject
{
    DSCaptureFullController *full;
    DSCaptureSelectionController *selection;
}

+ (DSCapture *) sharedCapture;

- (DSCaptureFullController *) full;
- (DSCaptureSelectionController *) selection;
@end
