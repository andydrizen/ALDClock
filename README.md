[![ScreenShot](https://raw.github.com/andydrizen/ALDClock/master/VideoScreenshot.png)](http://youtu.be/cH2hla6Cl_g)

## What is this?

An interactive clock component for use in iOS projects.

## How can I use it?

Add both `ALDClock.h` and `ALDClock.m` to your project, and then `#import "ALDClock.h"` into your own class. Create an instance of the clock by:

```
ALDClock *clock = [[ALDClock alloc] initWithFrame:self.view.bounds];
```

and add it to your view.

## CocoaPods

You can also add this project to yours by using CocoaPods. To do this, add the following line to your Podfile:

```
pod 'ALDClock`, '~>2.0'
```
