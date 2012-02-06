#import "DSCaptureSelectionController.h"
#import "DSCaptureSelectionWindow.h"

@interface DSCaptureSelectionController (CoreGraphics)

- (void) preCGCapture;
- (void) windowWillClose:(NSNotification *)notification;
- (void) postCGCapture: (DSCaptureSelectionWindow *) window;

@end

@implementation DSCaptureSelectionController (CoreGraphics)

- (void) preCGCapture
{
    // NSScreen으로 스크린 가져와서 DSCaptureSelectionWindow 만들고 selectionWindowArray에 추가하고 display
    selectionWindowArray = [[NSMutableArray alloc] init];
    
    for (NSScreen *screen in [NSScreen screens]) {
        DSCaptureSelectionWindow *selectionWindow = [[DSCaptureSelectionWindow alloc] initWithScreen:screen];
        [selectionWindowArray addObject:selectionWindow];
        
        [selectionWindow setDelegate:self];
        [selectionWindow makeKeyAndOrderFront:self];
        [selectionWindow display];
        
        [selectionWindow release];
    }
    
    // 현재 마우스가 있는 윈도우를 최상위로
    NSPoint mouse = [NSEvent mouseLocation];
    CGFloat mouseX = mouse.x;
    CGFloat mouseY = mouse.y;
    for (DSCaptureSelectionWindow *window in selectionWindowArray) {
        CGFloat windowXMin = window.displayRect.origin.x;
        CGFloat windowXMax = windowXMin + window.displayRect.size.width;
        CGFloat windowYMin = window.displayRect.origin.y;
        CGFloat windowYMax = windowYMin + window.displayRect.size.height;
        
        if (windowXMin < mouseX && mouseX < windowXMax) {
            if (windowYMin < mouseY && mouseY < windowYMax) {
                [window makeKeyAndOrderFront:self];
            }
        }
    }
}

- (void)windowWillClose:(NSNotification *)notification
{
    DSCaptureSelectionWindow *selectionWindow = [notification object];
    
    if(selectionWindow.isSelectionDone) {
        for (DSCaptureSelectionWindow *window in selectionWindowArray) {
            if (window != selectionWindow)
                [window close];
            
            [window.contentView setHidden:YES];
        }
        
        [self performSelectorOnMainThread:@selector(postCGCapture:) withObject:selectionWindow waitUntilDone:NO];
    }
}

- (void) postCGCapture: (DSCaptureSelectionWindow *) window
{
    if(!window.isSelectionDone)
        return;
    
    if(!(window.selectionRect.size.width && window.selectionRect.size.height)) // 가로 세로 크기가 없을 경우
        return;
    
    usleep(30000);
    
    // 디스플레이 전체 캡쳐해서 CGImageRef로 잘라서 NSData 형태로 DSCaptureData에 추가 
    CGDirectDisplayID mainID = window.displayID;
    CGImageRef mainCGImage = CGDisplayCreateImage(mainID); // 캡쳐!
    CGImageRef mainCroppedCGImage = CGImageCreateWithImageInRect(mainCGImage, window.selectionRect); // 크롭!
    CGImageRelease(mainCGImage);
    
    CFMutableDataRef mainMutData = CFDataCreateMutable(NULL, 0);
    CFStringRef dspyDestType = CFSTR("public.png");
    CGImageDestinationRef mainDest = CGImageDestinationCreateWithData(mainMutData, dspyDestType, 1, NULL);
    CFRelease(dspyDestType);
    
    CGImageDestinationAddImage(mainDest, mainCroppedCGImage, NULL);
    CGImageRelease(mainCroppedCGImage);
    
    CGImageDestinationFinalize(mainDest);
    CFRelease(mainDest);
    
    // 캡쳐된 디스플레이 데이터 받을 배열 준비
    DSCaptureData *data = [DSCaptureData data];
    [data addCaptureData:(NSMutableData *)mainMutData];
    CFRelease(mainMutData);
    
    if ([data count])
        [callbackTarget performSelectorOnMainThread:callbackSelector withObject:data waitUntilDone:NO];
    else
        return;
}

@end