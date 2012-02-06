#import <Foundation/Foundation.h>

@interface DSCaptureFullController : NSObject
{
    id callbackTarget;
    SEL callbackSelector;
}

- (id) init;

- (void) captureWithTarget: (id) target
                  selector: (SEL) selector
                     useCG: (BOOL) cg;

@end

