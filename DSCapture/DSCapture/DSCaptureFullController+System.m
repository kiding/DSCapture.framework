#import "DSCaptureFullController.h"
#import "DSCaptureData.h"

@interface DSCaptureFullController (System)

- (void) sysCapture;

@end

@implementation DSCaptureFullController (System)

- (void) sysCapture
{
    // 멀티 모니터를 위한 imgPathArray
    NSMutableArray *imgPathArray = [[NSMutableArray alloc] init];
    
    // 스크린 개수 받기
    NSUInteger screenCount = [[NSScreen screens] count];
    
    // Temp 폴더에 파일
    NSString *tempDir = NSTemporaryDirectory();
    
    for(int i=0; i<screenCount; i++) {
        NSString *imgPath = [[NSString alloc] initWithFormat:@"%@capture_%d_%d.png", tempDir, (int)time(NULL), i];
        [imgPathArray addObject:imgPath];
        [imgPath release];
    }
    
    // systemcapture NSTask 생성
    NSMutableArray *arg = [[NSMutableArray alloc] initWithObjects:@"-t", @"png", nil];
    [arg addObjectsFromArray:imgPathArray];
    
    NSTask *capture = [NSTask launchedTaskWithLaunchPath:@"/usr/sbin/screencapture" arguments:arg]; // 캡쳐!
    [capture waitUntilExit];
    [arg release];
    
    // 캡쳐된 디스플레이 데이터 받을 배열 준비
    DSCaptureData *data = [DSCaptureData data];

    // imgPath 있는 지 확인
    for(NSString *imgPath in imgPathArray) {
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
        [data addCaptureData:imgData];
    }
    [imgPathArray release];
    
    if ([data count])
        [callbackTarget performSelectorOnMainThread:callbackSelector withObject:data waitUntilDone:NO];
    else
        return;
    
}

@end
