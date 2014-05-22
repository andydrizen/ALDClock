//
//  ALDClock.m
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

#import "ALDClock.h"

typedef struct{
	double x;
	double y;
	double z;
} ALDVector3D;

@interface ALDClock ()
@property (nonatomic, assign) CGFloat totalRotation;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) UIColor *clockFaceBackgroundColor;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat targetRotation;
@end

const CGFloat kALDClockAnimationIncrement = 30;

@implementation ALDClock
@synthesize minute = _minute, hour = _hour;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)commonInit
{
	[super setBackgroundColor:[UIColor clearColor]];
	
	_secondsFromGMT = 0;
	
	// Have the hands pointing up initially.
	_totalRotation = 0;
	
	// How wide should the clock be?
	[self updateRadius];
	
	// Theminute hand can move smoothly or at second intervals.
	_minuteHandMovesSmoothly = NO;
	
	// Set default colours
	_clockFaceBackgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
	_majorMarkingColor = [UIColor colorWithWhite:0.3 alpha:1.0];
	_minorMarkingColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	_minuteHandColor = [UIColor colorWithWhite:0.2 alpha:1.0];
	_hourHandColor = [UIColor colorWithWhite:0.2 alpha:1.0];
	
	// Set default thicknesses
	_majorMarkingThickness = 1.0f;
	_minorMarkingThickness = 1.0f;
	_minuteHandThickness = 5.0f;
	_hourHandThickness = 5.0f;
	
	_majorMarkingLength = 5.0f;
	_minorMarkingLength = 1.0f;
	
	_markingsInset = 5.0f;
	
	// Set the border properties
	_borderWidth = 9.0f;
	_borderColor = [UIColor blackColor];
	
	// Setup the default text attributes
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.alignment = NSTextAlignmentCenter;
	
	_titleAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.2 alpha:1.0],
						 NSParagraphStyleAttributeName: paragraphStyle,
						 NSFontAttributeName : [UIFont systemFontOfSize:16.0f]};
	_subtitleAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.4 alpha:1.0],
							NSParagraphStyleAttributeName: paragraphStyle,
							NSFontAttributeName : [UIFont systemFontOfSize:13.0f]};
	
	_digitAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.0 alpha:1.0],
						 NSParagraphStyleAttributeName: paragraphStyle,
						 NSFontAttributeName : [UIFont systemFontOfSize:16.0f]};
}

- (void)updateRadius
{
    _radius = MIN(CGRectGetWidth(self.frame)/2.0f, CGRectGetHeight(self.frame)/2.0f) - 20;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateRadius];
}

#pragma mark - Public Methods

- (void)setHour:(NSInteger)hour animated:(BOOL)animated
{
    [self setHour:hour minute:_minute animated:animated];
}

- (void)setMinute:(NSInteger)minute animated:(BOOL)animated
{
    [self setHour:_hour minute:minute animated:animated];
}

- (void)setHour:(NSInteger)hour minute:(NSInteger)minute animated:(BOOL)animated
{
    if(self.isAnimating)
        return;
    
    CGFloat newHour = ((hour+self.hourOffset + 24) % 24);
    CGFloat newMinute = ((minute+self.minuteOffset + 60) % 60);
    if(minute+self.minuteOffset >= 60)
        newHour ++;
    else if(minute+self.minuteOffset < 0)
        newHour --;
    
    CGFloat rotation = [self rotationForHour:newHour minute:newMinute];
    self.targetRotation = rotation;
    
    if(animated)
    {
        [self animateClockToHour:newHour minute:newMinute];
    }
    else
    {
        _minute = minute;
        _hour = hour;
        
        self.totalRotation = rotation;
        [self updateDisplayAndListeners];
    }
}

- (void)setTitle:(NSString *)title
{
	_title = title;
	[self setNeedsDisplay];
}

- (void)setSubtitle:(NSString *)subtitle
{
	_subtitle = subtitle;
	[self setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self setNeedsDisplay];
}

- (void)setMajorMarkingColor:(UIColor *)majorMarkingColor
{
	_majorMarkingColor = majorMarkingColor;
	[self setNeedsDisplay];
}

-(void)setMinorMarkingColor:(UIColor *)minorMarkingColor
{
	_minorMarkingColor = minorMarkingColor;
	[self setNeedsDisplay];
}

- (void)setMajorMarkingLength:(CGFloat)majorMarkingLength
{
	_majorMarkingLength = majorMarkingLength;
	[self setNeedsDisplay];
}

- (void)setMinorMarkingLength:(CGFloat)minorMarkingLength
{
	_minorMarkingLength = minorMarkingLength;
	[self setNeedsDisplay];
}

- (void)setMajorMarkingThickness:(CGFloat)majorMarkingThickness
{
	_majorMarkingThickness = majorMarkingThickness;
	[self setNeedsDisplay];
}

- (void)setMinorMarkingThickness:(CGFloat)minorMarkingThickness
{
	_minorMarkingThickness = minorMarkingThickness;
	[self setNeedsDisplay];
}

- (void)setMarkingInset:(CGFloat)markingInset
{
	_markingsInset = markingInset;
	[self setNeedsDisplay];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    // As we always want the background of this view to be
    // clear, we override this default method an make it
    // change the background colour of the clock instead.
    
    self.clockFaceBackgroundColor = backgroundColor;
    [self setNeedsDisplay];
}

#pragma mark - Animation Methods

- (void)animateClockToHour:(NSInteger)hour minute:(NSInteger)minute
{
    // Flag animation to prevent interations
    self.isAnimating = YES;
    
    // Either snap to the target immediately, or fire a timer to animate
    if([self shouldSnapToTargetRotation])
    {
        [self snapToTarget];
    }
    else
    {
        if([self.timer isValid])
            [self.timer invalidate];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0f
                                                      target:self
                                                    selector:@selector(handleTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (BOOL)shouldSnapToTargetRotation
{
    // If we're within 1 increment, we should snap to the target
    if(abs(self.targetRotation - self.totalRotation) < kALDClockAnimationIncrement)
        return YES;
    else
        return NO;
}

- (void)snapToTarget
{
    // As we've been told to snap to the target angle, kill the timer
    if([self.timer isValid])
        [self.timer invalidate];
    
    // Perform the snap, then update the hour and minute.
    self.totalRotation = self.targetRotation;
    _hour = floor(fmod(-self.totalRotation/360.0f + 24, 24));
    _minute = floor(fmod(-self.totalRotation/6.0f + 60, 60));
    
    [self updateDisplayAndListeners];
    
    // No loger animating, so we'll allow interation again.
    self.isAnimating = NO;
}

- (void)handleTimer:(NSTimer *)timer
{
    // Find the shortest direction to spin and then add the increment
    // (possibly negative)
    
    if(fmod(self.targetRotation - self.totalRotation + 24 * 360, 24 * 360) <
       fmod(self.totalRotation - self.targetRotation + 24 * 360, 24 * 360))
    {
        self.totalRotation = fmod(self.totalRotation + kALDClockAnimationIncrement, 24 * 360);
    }
    else
    {
        self.totalRotation = fmod(self.totalRotation - kALDClockAnimationIncrement, 24 * 360);
    }
    
    // Update the hour and minute
    _hour = floor(fmod(-self.totalRotation/360.0f + 24, 24));
    _minute = floor(fmod(-self.totalRotation/6.0f + 60, 60));
    
    // Check to see if we should snap to the target, or just update
    // the view and any listeners.
    
    if([self shouldSnapToTargetRotation])
        [self snapToTarget];
    else
        [self updateDisplayAndListeners];
}

- (void)updateDisplayAndListeners
{
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
}

#pragma mark - Tracking Methods

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    [self sendActionsForControlEvents:UIControlEventTouchDragEnter];
    
    //We need to track continuously
    return YES;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    if(self.isAnimating)
        return NO;
    
    //Get touch location
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint previousPoint = [touch previousLocationInView:self];
    
    //Use the location to design the Handle
    [self moveHandFromPoint:previousPoint toPoint:currentPoint];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self sendActionsForControlEvents:UIControlEventTouchDragExit];
}

#pragma mark - Handle Tracking

-(void)moveHandFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
    
    ALDVector3D u1 = [self vectorFromPoint:center toPoint:fromPoint];
    ALDVector3D u2 = [self vectorFromPoint:center toPoint:toPoint];
    
    // We find the smallest angle between these two vectors
    double deltaAngle = [self angleBetweenVector:u1 andVector:u2];
    
    // Calculate if we are moving clockwise or anti-clockwise
    double directedDeltaAngle = ([self isMovingCounterClockwise:u1 vector:u2]) ? deltaAngle : -1 * deltaAngle;
    
    // Update the total rotation
    self.totalRotation = fmod(self.totalRotation + directedDeltaAngle, 24 * 360);
    
    // Update the hour and minute properties
    _hour = floor(fmod(-self.totalRotation/360.0f + 24, 24));
    _minute = floor(fmod(-self.totalRotation/6.0f + 60, 60));
    
    //Redraw
    [self updateDisplayAndListeners];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint center = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f);
    
    // We find a max width to ensure that the clock is always
    // bounded by a square box
    
    CGFloat maxWidth = MIN(self.frame.size.width, self.frame.size.height);
    
    // Create a rect that maximises the area of the clock in the
    // square box
    
    CGRect rectForClockFace = CGRectInset(CGRectMake((self.frame.size.width - maxWidth)/2.0f,
                                                     (self.frame.size.height - maxWidth)/2.0f,
                                                     maxWidth,
                                                     maxWidth), 2*self.borderWidth, 2*self.borderWidth);
    
    // --------------------------
    // -- Draw the background  --
    // --------------------------
    
    // Draw the clock background
    CGContextSetFillColorWithColor(context, self.clockFaceBackgroundColor.CGColor);
    CGContextFillEllipseInRect(context, rectForClockFace);
    
    // --------------------------
    // --    Draw the title    --
    // --------------------------
    
    CGRect titleRect = CGRectMake(CGRectGetMinX(rectForClockFace) + CGRectGetWidth(rectForClockFace)*0.2f,
                                  CGRectGetMinY(rectForClockFace) + CGRectGetHeight(rectForClockFace)*0.25f,
                                  CGRectGetWidth(rectForClockFace)*0.6f,
                                  20.0f);
    
    [self.title drawInRect:titleRect withAttributes:self.titleAttributes];
    
    // --------------------------
    // --  Draw the subtitle   --
    // --------------------------
    
    CGRect subtitleRect = CGRectMake(CGRectGetMinX(rectForClockFace) + CGRectGetWidth(rectForClockFace)*0.2f,
                                     CGRectGetMinY(rectForClockFace) + CGRectGetHeight(rectForClockFace)*0.65f,
                                     CGRectGetWidth(rectForClockFace)*0.6f,
                                     20.0f);
    
    [self.subtitle drawInRect:subtitleRect withAttributes:self.subtitleAttributes];
    
    // --------------------------
    // --  Draw the markings   --
    // --------------------------
    
    // Set the colour of the major markings
    CGContextSetStrokeColorWithColor(context, self.majorMarkingColor.CGColor);
    // Set the major marking width
    CGContextSetLineWidth(context, self.majorMarkingThickness);
    
    // Draw the major markings
    for(unsigned i = 0; i < 12; i ++)
    {
        // Get the location of the end of the hand
        CGFloat markingDistanceFromCenter = rectForClockFace.size.width/2.0f - self.markingsInset;
        
        CGFloat markingX1 = center.x + markingDistanceFromCenter * cos((M_PI/180)* i * 30 + M_PI);
        CGFloat markingY1 = center.y + - 1 * markingDistanceFromCenter * sin((M_PI/180)* i * 30);
        CGFloat markingX2 = center.x + (markingDistanceFromCenter - self.majorMarkingLength) * cos((M_PI/180)* i * 30 + M_PI);
        CGFloat markingY2 = center.y + - 1 * (markingDistanceFromCenter - self.majorMarkingLength) * sin((M_PI/180)* i * 30);
        
        // Move the cursor to the edge of the marking
        CGContextMoveToPoint(context, markingX1, markingY1);
        
        // Move to the end of the hand
        CGContextAddLineToPoint(context, markingX2, markingY2);
    }
    
    // Draw minor markings.
    CGContextDrawPath(context, kCGPathStroke);
    
    // Set the colour of the minor markings
    CGContextSetStrokeColorWithColor(context, self.minorMarkingColor.CGColor);
    
    // Set the minor minor width
    CGContextSetLineWidth(context, self.minorMarkingThickness);
    
    for(NSInteger i = 0; i < 60; i ++)
    {
        // Don't put a minor mark if there's already a major mark
        if ((i % 5) == 0)
            continue;
        
        // Get the location of the end of the hand
        CGFloat markingDistanceFromCenter = rectForClockFace.size.width/2.0f -  self.markingsInset;
        
        CGFloat markingX1 = center.x + markingDistanceFromCenter * cos((M_PI/180)* i * 6 + M_PI);
        CGFloat markingY1 = center.y + - 1 * markingDistanceFromCenter * sin((M_PI/180)* i * 6);
        
        CGFloat markingX2 = center.x + (markingDistanceFromCenter - self.minorMarkingLength) * cos( (M_PI/180)* i * 6+ M_PI);
        CGFloat markingY2 = center.y + - 1 * (markingDistanceFromCenter - self.minorMarkingLength) * sin((M_PI/180)* i * 6);
        
        // Move the cursor to the edge of the marking
        CGContextMoveToPoint(context, markingX1, markingY1);
        
        // Move to the end of the hand
        CGContextAddLineToPoint(context, markingX2, markingY2);
    }
    
    // Draw minor markings.
    CGContextDrawPath(context, kCGPathStroke);
    
    // Draw the digits
    for(unsigned i = 0; i < 12; i ++)
    {
        UIFont *digitFont = self.digitAttributes[NSFontAttributeName];
        
        CGFloat markingDistanceFromCenter = rectForClockFace.size.width/2.0f - digitFont.lineHeight/4.0f - self.markingsInset - MAX(self.majorMarkingLength, self.minorMarkingLength);
        NSInteger offset = 4;
        
        CGFloat labelX = center.x + (markingDistanceFromCenter - digitFont.lineHeight/2.0f) * cos( (M_PI/180)* (i+offset) * 30 + M_PI);
        CGFloat labelY = center.y + - 1 * (markingDistanceFromCenter - digitFont.lineHeight/2.0f) * sin((M_PI/180)*(i+offset) * 30);
        
        NSString *hourNumber = [NSString stringWithFormat:@"%d", i + 1];
        [hourNumber drawInRect:CGRectMake(labelX - digitFont.lineHeight/2.0f,
                                          labelY - digitFont.lineHeight/2.0f,
                                          digitFont.lineHeight,
                                          digitFont.lineHeight)
                withAttributes:self.digitAttributes];
    }
    
    // --------------------------
    // --  Draw the hour hand  --
    // --------------------------
    
    // Set the hand width
    CGContextSetLineWidth(context, self.hourHandThickness);
    
    // Set the colour of the hand
    CGContextSetStrokeColorWithColor(context, self.hourHandColor.CGColor);
    
    // Offset the hour hand by 90 degrees
    CGFloat hourHandAngle = fmod(self.totalRotation * 1/12.0f, 360);
    hourHandAngle += 90;
    
    // Move the cursor to the center
    CGContextMoveToPoint(context, center.x, center.y);
    
    // Get the location of the end of the hand
    CGFloat hourHandX = center.x + (0.6*self.radius) * cos((M_PI/180)*hourHandAngle);
    CGFloat hourHandY = center.y + - 1 * (0.6*self.radius) * sin((M_PI/180)*hourHandAngle);
    
    // Move to the end of the hand
    CGContextAddLineToPoint(context, hourHandX, hourHandY);
    
    // Draw hour hand.
    CGContextDrawPath(context, kCGPathStroke);
    
    // --------------------------
    // -- Draw the minute hand --
    // --------------------------
    
    // Set the hand width
    CGContextSetLineWidth(context, self.minuteHandThickness);
    
    // Set the colour of the hand
    CGContextSetStrokeColorWithColor(context, self.minuteHandColor.CGColor);
    
    CGFloat minuteHandAngle = ceil(fmod(self.totalRotation + 24 * 360, 24 * 360) / 6.0f) * 6;
    if(self.minuteHandMovesSmoothly)
        minuteHandAngle = self.totalRotation;
    
    // Offset the minute hand by 90 degrees
    minuteHandAngle += 90;
    
    // Move the cursor to the center
    CGContextMoveToPoint(context, center.x, center.y );
    
    // Get the location of the end of the hand
    CGFloat minuteHandX = center.x + 0.90*self.radius * cos((M_PI/180)*minuteHandAngle);
    CGFloat minuteHandY = center.y + - 1 * 0.90*self.radius * sin((M_PI/180)*minuteHandAngle);
    
    // Move to the end of the hand
    CGContextAddLineToPoint(context, minuteHandX, minuteHandY);
    
    // Draw minute hand.
    CGContextDrawPath(context, kCGPathStroke);
    
    // --------------------------
    // -- Draw the centre cap  --
    // --------------------------
    
    CGContextSetFillColorWithColor(context, self.minuteHandColor.CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(CGRectGetMidX(rectForClockFace)-8,
                                                   CGRectGetMidY(rectForClockFace)-8,
                                                   16,
                                                   16)
                               );
    
    // --------------------------
    // --   Draw the stroke    --
    // --------------------------
    
    
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextSetLineWidth(context, 2 * self.borderWidth);
    CGContextAddEllipseInRect(context, CGRectInset(rectForClockFace, -self.borderWidth, -self.borderWidth));
    CGContextDrawPath(context, kCGPathStroke);
    
}

- (CGFloat)rotationForHour:(CGFloat)hour minute:(NSInteger)minute
{
    return -minute * 6 -hour * 360;
}

#pragma mark - Custom Accessors

- (NSInteger)minute
{
    return (_minute + 60) % 60;
}

- (NSInteger)hour
{
    return (_hour + 24) % 24;
}

- (CGFloat)targetRotation
{
    return fmod(fmod(_targetRotation, 24 * 360) + 24 * 360, 24 * 360);
}

- (CGFloat)totalRotation
{
    return fmod(fmod(_totalRotation, 24 * 360) + 24 * 360, 24 * 360);
}

- (BOOL)isAM
{
    return self.totalRotation > 4320? YES : NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%02d:%02d, isAM:%d, isAnimating:%d", (int)self.hour, (int)self.minute, self.isAM, self.isAnimating];
}

#pragma mark - Custom Setters

- (void)setHour:(NSInteger)hour
{
    [self setHour:hour animated:NO];
}

- (void)setMinute:(NSInteger)minute
{
    [self setMinute:minute animated:NO];
}

#pragma mark - Vector Math

- (ALDVector3D)vectorFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
	ALDVector3D v = {toPoint.x - fromPoint.x, toPoint.y - fromPoint.y, 0};
	return v;
}

- (CGFloat)dotProductOfVector:(ALDVector3D)v1 andVector:(ALDVector3D)v2
{
	CGFloat value = v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
    return value;
}

- (CGFloat)angleBetweenVector:(ALDVector3D)v1 andVector:(ALDVector3D)v2
{
    CGFloat normOfv1 = sqrt([self dotProductOfVector:v1 andVector:v1]);
    CGFloat normOfv2 = sqrt([self dotProductOfVector:v2 andVector:v2]);
    
	CGFloat angle = (180/M_PI) * acos( fmin([self dotProductOfVector:v1 andVector:v2] / (normOfv1 * normOfv2), 1) );
	return angle;
}

- (ALDVector3D)crossProductOfVector:(ALDVector3D)v1 andVector:(ALDVector3D)v2
{
	ALDVector3D v;
	v.x = v1.y*v2.z - v1.z*v2.y;
	v.y = -1 * (v1.x*v2.z - v1.z*v2.x);
	v.z = v1.x*v2.y - v1.y*v2.x;
	
	return v;
}

- (BOOL)isMovingCounterClockwise:(ALDVector3D)v1 vector:(ALDVector3D)v2
{
	ALDVector3D normal = {0,0,1};
    ALDVector3D crossProduct = [self crossProductOfVector:v1 andVector:v2];
	BOOL isCounterClockwise = ([self dotProductOfVector:crossProduct andVector:normal] < 0)? YES : NO;
    return isCounterClockwise;
}

- (NSInteger)hourOffset
{
    return floor(self.secondsFromGMT/(60*60.0f));
}

- (NSInteger)minuteOffset
{
    return floor(self.secondsFromGMT/(60.0f)) - 60*self.hourOffset;
}

@end
