//
//  ALDClock.h
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

#import <UIKit/UIKit.h>

@interface ALDClock : UIControl

/**
 The hour that the clock is currently displaying.
 */
@property (nonatomic, assign) NSInteger hour;

/**
 The minute that the clock is currently displaying.
 */
 @property (nonatomic, assign) NSInteger minute;

/**
 When setting a time, you may wish to always work with UTC. In this case,
 you can provide an offset for other locales.
 */
@property (nonatomic, assign) NSInteger secondsFromGMT;

/**
 Provides the hour component (in the range +/- [0,24]) that this clock is ahead 
 or behind compared to GMT
 */
@property (nonatomic, assign, readonly) NSInteger hourOffset;

/**
 Provides the minute component (in the range +/-[0, 60]) that this clock is ahead 
 or behind compared to GMT. 
 */
@property (nonatomic, assign, readonly) NSInteger minuteOffset;

/**
 A short string shown near the top of the clock.
 */
@property (nonatomic, strong) NSString *title;

/**
 A short string shown near the bottom of the clock.
 */
@property (nonatomic, strong) NSString *subtitle;

/**
 Attributes that describe how the title should be rendered.
 */
@property (nonatomic, strong) NSDictionary *titleAttributes;

/**
 Attributes that describe how the subtitle should be rendered.
 */
@property (nonatomic, strong) NSDictionary *subtitleAttributes;

/**
 Attributes that describe how the digits should be rendered.
 */
@property (nonatomic, strong) NSDictionary *digitAttributes;

/**
 By setting this to YES, the minute hand will move slowly around
 the clock when the user drags. Default is NO.
 */
@property (nonatomic, assign) BOOL minuteHandMovesSmoothly;

/**
 The color of the major markings (the hours markers)
 */
@property (nonatomic, strong) UIColor *majorMarkingColor;

/**
 The color of the major markings (the minute markers)
 */
@property (nonatomic, strong) UIColor *minorMarkingColor;

/**
 The thickness of the major markings  (the hours markers)
 */
@property (nonatomic, assign) CGFloat majorMarkingThickness;

/**
 The thickness of the minor markings  (the minute markers)
 */
@property (nonatomic, assign) CGFloat minorMarkingThickness;

/**
 The length of the major markings  (the hour markers)
 */
@property (nonatomic, assign) CGFloat majorMarkingLength;

/**
 The length of the minor markings  (the minute markers)
 */
@property (nonatomic, assign) CGFloat minorMarkingLength;

/**
 The distance the markings are presented from the circumference
 of the clock
 */
@property (nonatomic, assign) CGFloat markingsInset;

/**
 Color of the minute hand.
 */
@property (nonatomic, strong) UIColor *minuteHandColor;

/**
 Color of the hour hand.
 */
@property (nonatomic, strong) UIColor *hourHandColor;

/**
 Thickness of the minute hand.
 */
@property (nonatomic, assign) CGFloat minuteHandThickness;

/**
 Thickness of the hour hand.
 */
@property (nonatomic, assign) CGFloat hourHandThickness;

/**
 Color of the border of the clock
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 Thickness of the border of the clock
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 Describes whether the clock is showing an AM or PM time
 */
@property (nonatomic, assign, readonly) BOOL isAM;

/**
 @param hour The hour the clock should display
 @param minnute The minute the clock should display
 @param animated Should the transition be animated
 */
- (void)setHour:(NSInteger)hour minute:(NSInteger)minute animated:(BOOL)animated;

/**
 @param hour The hour the clock should display
 @param animated Should the transition be animated
 */
- (void)setHour:(NSInteger)hour animated:(BOOL)animated;

/**
 @param minnute The minute the clock should display
 @param animated Should the transition be animated
 */
- (void)setMinute:(NSInteger)minute animated:(BOOL)animated;
@end
