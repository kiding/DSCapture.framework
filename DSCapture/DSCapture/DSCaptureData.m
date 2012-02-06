#import "DSCaptureData.h"

@implementation DSCaptureData

+ (id) data
{
    return [[[self alloc] init] autorelease];
}

- (id) init
{
    self = [super init];
    if(self) {
        data = [[NSMutableArray alloc] init];
        image = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addCaptureData: (NSData *) newData
{
    if(!newData)
        return;
    
    // 캡쳐된 Data를 Image로 바꾸기
    NSImage *newImage = [[NSImage alloc] initWithData:newData];
    
    if(!newImage)
        return;
    
    [data addObject:newData];
    [image addObject:newImage];
    
    [newImage release];    
}

- (NSUInteger) count
{
    return [data count];
}

- (NSData *) dataAtIndex: (NSUInteger) index
{
    return [data objectAtIndex:index];
}

- (NSImage *) imageAtIndex: (NSUInteger) index
{
    return [image objectAtIndex:index];
}

- (void) dealloc
{
    [data release];
    [image release];
    
    [super dealloc];
}
@end
