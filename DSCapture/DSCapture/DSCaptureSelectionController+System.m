#import "DSCaptureSelectionController.h"

@interface DSCaptureSelectionController (System)

- (void) preSysCapture;
- (void) postSysCapture: (NSString *) imgPath;

@end

@implementation DSCaptureSelectionController (System)

- (void) preSysCapture
{
    // Temp 폴더에 파일
    NSString *tempDir = NSTemporaryDirectory();
    NSString *imgPath = [[NSString alloc] initWithFormat:@"%@capture_%d.png", tempDir, (int)time(NULL)];
    
    // systemcapture NSTask 생성
    NSArray *arg = [[NSArray alloc] initWithObjects:@"-i", @"-t", @"png", imgPath, nil];
    [imgPath release];
    
    NSTask *capture = [NSTask launchedTaskWithLaunchPath:@"/usr/sbin/screencapture" arguments:arg]; // 캡쳐!
    [capture waitUntilExit];
    [arg release];
    
    [self performSelectorOnMainThread:@selector(postSysCapture:) withObject:imgPath waitUntilDone:NO];
}

- (void) postSysCapture: (NSString *) imgPath
{
    // imgPath 있는 지 확인
    NSURL *imgURL = [[NSURL alloc] initFileURLWithPath:imgPath];
    for(int i=0; i<3; i++) {
        if([imgURL checkResourceIsReachableAndReturnError:nil])
            break;
        else
            usleep(500000);
    }
    
    // imgURL 데이터 가져오기
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingFromURL:imgURL error:nil];
    [imgURL release];
    
    NSData *imgData = [handle readDataToEndOfFile];
    
    // 캡쳐된 디스플레이 데이터 받을 배열 준비
    DSCaptureData *data = [DSCaptureData data];
    [data addCaptureData:imgData];
    
    if ([data count])
        [callbackTarget performSelectorOnMainThread:callbackSelector withObject:data waitUntilDone:NO];
    else
        return;
}

@end