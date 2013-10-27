//
//  ALDRootViewController.m
//  ALDClock
//
//  Copyright (c) 2013, Andy Drizen
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL ANDY DRIZEN BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "ALDRootViewController.h"
#import "ALDClock.h"

@interface ALDRootViewController ()
@property (nonatomic, strong) ALDClock *clock;
@end

@implementation ALDRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupClock];
    [self applyClockCustomisations];
}

#pragma mark - Clock Setup Methods

- (void)setupClock
{
    // Create an instance of the clock with a given frame.
    CGRect clockFrame = CGRectMake(0,0,CGRectGetWidth(self.view.bounds)*0.9,CGRectGetHeight(self.view.bounds)*0.9);
    self.clock = [[ALDClock alloc] initWithFrame:clockFrame];
    
    // Put the clock in the centre of the frame
    self.clock.center = self.view.center;
    
    // Add the clock to the view.
    [self.view addSubview:self.clock];
}

- (void)applyClockCustomisations
{
    // Change the background color of the clock (note that this is the color
    // of the clock face)
    self.clock.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    
    // Add a title and subtitle to the clock face
    self.clock.title = @"ALDClock";
    self.clock.subtitle = @"By Andy Drizen";
    
    // When the time changes, call the the clockDidChangeTime: method.
    [self.clock addTarget:self action:@selector(clockDidChangeTime:) forControlEvents:UIControlEventValueChanged];
    
    // When the user begins/ends manually changing the time, call these methods.
    [self.clock addTarget:self action:@selector(clockDidBeginDragging:) forControlEvents:UIControlEventTouchDragEnter];
    [self.clock addTarget:self action:@selector(clockDidEndDragging:) forControlEvents:UIControlEventTouchDragExit];
    
    // Set the initial time
    [self.clock setHour:13 minute:51 animated:NO];
    
    // Change the clock's border color and width
    self.clock.borderColor = [UIColor colorWithRed:0.22 green:0.78 blue:0.22 alpha:1.0];
    self.clock.borderWidth = 4.0f;
}

#pragma mark - Clock Callback Methods

- (void)clockDidChangeTime:(ALDClock *)clock
{
    NSLog(@"The time is: %02d:%02d", clock.hour, clock.minute);
}

- (void)clockDidBeginDragging:(ALDClock *)clock
{
    clock.borderColor = [UIColor colorWithRed:0.78 green:0.22 blue:0.22 alpha:1.0];
}

- (void)clockDidEndDragging:(ALDClock *)clock
{
    clock.borderColor = [UIColor colorWithRed:0.22 green:0.78 blue:0.22 alpha:1.0];
}

@end
