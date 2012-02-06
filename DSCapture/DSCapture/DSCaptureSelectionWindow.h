#import "DSCaptureSelectionView.h"

@interface DSCaptureSelectionWindow : NSWindow
{
    CGDirectDisplayID displayID;
    NSRect displayRect;
    
    NSPoint originPoint;
    NSRect viewRect;
    
    BOOL isSelectionDone;
    CGRect selectionRect;
    
    NSTrackingArea *trackingArea;
    DSCaptureSelectionView *selectionView;
}

@property (readonly) CGDirectDisplayID displayID;
@property (readonly) NSRect displayRect;

@property (readonly) BOOL isSelectionDone;
@property (readonly) CGRect selectionRect;

- (BOOL)canBecomeKeyWindow;
- (BOOL)acceptsFirstResponder;
- (BOOL)acceptsMouseMovedEvents;

- (id) initWithScreen: (NSScreen *) screen;

- (void)display;

- (void)mouseEntered:(NSEvent *)theEvent;
- (void)mouseMoved:(NSEvent *)theEvent;

- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;
- (void)keyDown:(NSEvent *)theEvent;

- (void)close;

@end
