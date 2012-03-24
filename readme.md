# DSCapture.framework

This framework enables you to easily implement screenshot functionality on your Mac OS X applications. It can capture whole screens, or a part of them, make them into NSData and NSImage. There are two ways to capture display.

* Core Graphics: Using Quartz Display Services, screen data goes directly to memory. Fast, but no window selection mode.

* System: Using Mac OS X's screencapture, screen data goes to temp folder (/var/folders) once and loads back to memory. Slow, but great window selection mode.

With the framework, you can choose which one to use. See how below.

# Using the Framework

Please try to check out ScreenCaptureTest application.

Download the framework, add it to your project, and:

	#import <DSCapture/DSCapture.h> 

If you don't know how, read [this][1].

At first, you need to make a callback method which has (DSCaptureData *) as a parameter, something like this:

	- (void)displayCaptureData: (DSCaptureData *) sender;

DSCapture is a singleton class - using it is fairly easy. 
To capture fullscreen, you should invoke:

	[[[DSCapture sharedCapture] full] captureWithTarget:self selector:@selector(displayCaptureData:) useCG:NO];

then it will call back the selector right after the capturing process.

To capture selection, you should invoke:

	[[[DSCapture sharedCapture] selection] captureWithTarget:self selector:@selector(displayCaptureData:) useCG:NO];

then it will popup an interface to select, and call back. If the user cancels it, no method will be called back.

At the callback method, you can:

	NSData *data = [sender dataAtIndex:0];
	NSImage *image = [sender imageAtIndex:0];

to get data and image. Also you can call:

	NSUInteger count = [sender count];

to get number of images of the sender. Normally, the number isn't bigger than 1 - except the user is using multiple displays.

# License

This framework follows MIT License.

Copyright (C) 2012 by Dongsung "Don" Kim
 
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

[1]: https://github.com/andymatuschak/Sparkle/wiki


