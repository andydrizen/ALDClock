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
 The hour and minute that the clock is currently displaying.
 */
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;

/**
 When setting a time, you may wish to always work with UTC. In this case,
 you can provide an offset for other locales.
 */
@property (nonatomic, assign) NSInteger hourOffset;
@property (nonatomic, assign) NSInteger minuteOffset;

/**
 A short string shown near the top of the clock.
 */
@property (nonatomic, strong) NSString *title;

/**
 A short string shown near the bottom of the clock.
 */
@property (nonatomic, strong) NSString *subtitle;

/**
 Attributes that describe how the title, subtitle and digits 
 should be rendered.
 */
@property (nonatomic, strong) NSDictionary *titleAttributes;
@property (nonatomic, strong) NSDictionary *subtitleAttributes;
@property (nonatomic, strong) NSDictionary *digitAttributes;

/**
 By setting this to YES, the minute hand will move slowly around
 the clock when the user drags. Default is NO.
 */
@property (nonatomic, assign) BOOL minuteHandMovesSmoothly;

/**
 Customisation for the markings that are displayed around the circumference
 of the clock.
 */
@property (nonatomic, strong) UIColor *majorMarkingColor;
@property (nonatomic, strong) UIColor *minorMarkingColor;
@property (nonatomic, assign) CGFloat majorMarkingsThickness;
@property (nonatomic, assign) CGFloat minorMarkingsThickness;
@property (nonatomic, assign) CGFloat majorMarkingsLength;
@property (nonatomic, assign) CGFloat minorMarkingsLength;
@property (nonatomic, assign) CGFloat markingsInset;

/**
 Customisation for the clock hands.
 */
@property (nonatomic, strong) UIColor *minuteHandColor;
@property (nonatomic, strong) UIColor *hourHandColor;
@property (nonatomic, assign) CGFloat minuteHandThickness;
@property (nonatomic, assign) CGFloat hourHandThickness;

/**
 Customisation for the border the clock.
 */
@property (nonatomic, strong) UIColor *borderColor;
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
