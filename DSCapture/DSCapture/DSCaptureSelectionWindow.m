#import "DSCaptureSelectionWindow.h"

@implementation DSCaptureSelectionWindow

@synthesize displayID, displayRect, isSelectionDone, selectionRect;

- (BOOL)canBecomeKeyWindow
{
	return YES;
}

- (BOOL) acceptsFirstResponder
{
    return YES;
}

- (BOOL)acceptsMouseMovedEvents
{
    return YES;
}

- (id) initWithScreen: (NSScreen *) scr
{
    if (!scr)
        return nil;
    
    displayRect = [scr frame];
    
    // displayRect 기반으로 displayID 가져오기
    CGDirectDisplayID dspyIDArray[1];
    uint32_t dspyIDCount = 0;
    if(CGGetDisplaysWithRect(displayRect, 1, dspyIDArray, &dspyIDCount) == kCGErrorSuccess)
        displayID = dspyIDArray[0];
    else
        return nil;
    
    self = [super initWithContentRect:displayRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:YES];
    
    if (self) {
        [self setLevel:NSMainMenuWindowLevel+1];
        [self setOpaque:NO];
        [self setBackgroundColor:[[NSColor whiteColor] colorWithAlphaComponent:0.1f]];
        [self setReleasedWhenClosed:NO];
        [self setOneShot:YES];
        
        originPoint = NSMakePoint(-1, -1);
        
        isSelectionDone = NO;
        selectionRect = NSMakeRect(-1, -1, -1, -1);
        
        trackingArea = [[NSTrackingArea alloc] initWithRect:NSMakeRect(0, 0, displayRect.size.width, displayRect.size.height)
                                                    options:NSTrackingActiveAlways + NSTrackingMouseMoved + NSTrackingMouseEnteredAndExited
                                                      owner:self
                                                   userInfo:nil];
        selectionView = [[DSCaptureSelectionView alloc] init];
    }
    
    return self;
}

- (void)display
{
    [[NSCursor crosshairCursor] set];
    [self.contentView addTrackingArea:trackingArea];
    [super display];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [self makeKeyAndOrderFront:self];
    [[NSCursor crosshairCursor] set];
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    [self makeKeyAndOrderFront:self];
    [[NSCursor crosshairCursor] set];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    originPoint = [theEvent locationInWindow];
    viewRect = NSMakeRect(originPoint.x, originPoint.y, 0, 0);
    [selectionView setFrame:viewRect];
    [[self contentView] addSubview:selectionView];
    [[NSCursor crosshairCursor] set];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint currentPoint = [theEvent locationInWindow];
    
    CGFloat viewX = currentPoint.x > originPoint.x ? originPoint.x : currentPoint.x;
    CGFloat viewY = currentPoint.y > originPoint.y ? originPoint.y : currentPoint.y;
    CGFloat viewW = currentPoint.x > originPoint.x ? currentPoint.x - originPoint.x : originPoint.x - currentPoint.x;
    CGFloat viewH = currentPoint.y > originPoint.y ? currentPoint.y - originPoint.y : originPoint.y - currentPoint.y;
    
    viewRect = NSMakeRect(viewX, viewY, viewW, viewH);
    [selectionView setFrame:viewRect];
    [[NSCursor crosshairCursor] set];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    isSelectionDone = YES;
    
    // viewRect는 왼쪽 아래가 0,0이지만 selectionRect는 왼쪽 위가 0,0
    selectionRect = CGRectMake(viewRect.origin.x, 
                               displayRect.size.height - viewRect.origin.y - viewRect.size.height, 
                               viewRect.size.width,
                               viewRect.size.height);
    
    [self close];
}

- (void)keyDown:(NSEvent *)theEvent
{
    if([theEvent keyCode] == 53)
        [self close];
}

- (void)close
{
    [NSCursor pop];
    [self.contentView removeTrackingArea:trackingArea];
    [super close];
}

- (void) dealloc
{
    [trackingArea release];
    [selectionView release];
    
    [super dealloc];
}

@end
