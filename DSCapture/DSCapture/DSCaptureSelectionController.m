#import "DSCaptureSelectionController.h"
#import "DSCaptureSelectionWindow.h"

@implementation DSCaptureSelectionController 

- (id) init
{
    self = [super init];
    if (self) {
        // callback 타겟 & 셀렉터 초기화
        callbackTarget = nil;
        callbackSelector = nil;
        
        // for Core Graphics
        selectionWindowArray = nil;
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
        [self performSelectorInBackground:@selector(preCGCapture) withObject:nil];
    else
        [self performSelectorInBackground:@selector(preSysCapture) withObject:nil];
}

- (void) dealloc
{
    if(selectionWindowArray)
        [selectionWindowArray release];
    
    [super dealloc];
}

@end