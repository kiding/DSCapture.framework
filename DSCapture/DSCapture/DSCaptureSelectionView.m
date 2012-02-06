#import "DSCaptureSelectionView.h"

@implementation DSCaptureSelectionView

- (void)drawRect:(NSRect)dirtyRect
{
    [[[NSColor blackColor] colorWithAlphaComponent:0.1f] setFill];
    NSRectFill(dirtyRect);
}

@end
