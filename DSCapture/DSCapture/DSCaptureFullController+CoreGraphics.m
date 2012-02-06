#import "DSCaptureFullController.h"
#import "DSCaptureData.h"

@interface DSCaptureFullController (CoreGraphics)

- (void) cgCapture;

@end

@implementation DSCaptureFullController (CoreGraphics)

- (void) cgCapture
{
    // 열려 있는 디스플레이 ID들 받기
    CGDirectDisplayID dspyIDArray[10];
    uint32_t dspyIDCount = 0;
    if(CGGetActiveDisplayList(10, dspyIDArray, &dspyIDCount) != kCGErrorSuccess)
        return;
    
    // 캡쳐된 디스플레이 데이터 받을 배열 준비
    DSCaptureData *data = [DSCaptureData data];
    
    // 디스플레이 캡쳐해서 NSData 형태로 DSCaptureData에 추가
    CFStringRef dspyDestType = CFSTR("public.png");
    
    for(uint32_t i=0; i<dspyIDCount; i++) {
        CGDirectDisplayID mainID = dspyIDArray[i];
        CGImageRef mainCGImage = CGDisplayCreateImage(mainID); // 캡쳐!
        
        CFMutableDataRef mainMutData = CFDataCreateMutable(NULL, 0);
        CGImageDestinationRef mainDest = CGImageDestinationCreateWithData(mainMutData, dspyDestType, 1, NULL);
        CGImageDestinationAddImage(mainDest, mainCGImage, NULL);
        CGImageRelease(mainCGImage);
        
        CGImageDestinationFinalize(mainDest);
        CFRelease(mainDest);
        
        [data addCaptureData:(NSMutableData *)mainMutData];
        CFRelease(mainMutData);
    }
    
    CFRelease(dspyDestType);
    
    if ([data count])
        [callbackTarget performSelectorOnMainThread:callbackSelector withObject:data waitUntilDone:NO];
    else
        return;
}

@end
