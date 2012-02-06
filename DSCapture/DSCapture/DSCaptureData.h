#import <Foundation/Foundation.h>

@interface DSCaptureData : NSObject
{
    NSMutableArray *data;
    NSMutableArray *image;
}

+ (id) data;

- (id) init;

- (void) addCaptureData: (NSData *) newData;

- (NSUInteger) count;

- (NSData *) dataAtIndex: (NSUInteger) index;
- (NSImage *) imageAtIndex: (NSUInteger) index;

@end
