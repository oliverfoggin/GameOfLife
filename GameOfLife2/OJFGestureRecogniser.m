//
//  OJFGestureRecogniser.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 13/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "OJFGestureRecogniser.h"

@interface OJFGestureRecogniser ()

@property BOOL tracking;
@property (strong) NSMutableArray *touches;
@property (strong) NSTimer *timer;
@property float startDistance;

- (void)processTouches;
- (void)switchToDrawing;

@end

@implementation OJFGestureRecogniser



- (id)init
{
    self = [super init];
    if (self) {
        _scaleFactor = 1.0;
        _vectorOffset = CGPointMake(0, 0);
        [self reset];
    }
    return self;
}

- (void)reset{
	[super reset];
    self.startPoint = CGPointZero;
    self.type = CustomGestureTypeUnknown;
    [self.timer invalidate];
    self.timer = nil;
    self.vectorOffset = _vectorOffset;
    self.touches = [NSMutableArray array];
    self.scaleFactor = _scaleFactor;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self addTouches:touches];
}

- (void)addTouches:(NSSet *)objects
{
    if ([self.touches count] == 2) {
        return;
    }
    
    for (UITouch *newTouch in objects) {
        if (![self.touches containsObject:newTouch]) {
            [self.touches addObject:newTouch];
        }
    }
    
    if ([self.touches count] == 1) {
        self.state = UIGestureRecognizerStatePossible;
        UITouch *touch = [self.touches objectAtIndex:0];
        self.startPoint = [touch locationInView:self.view];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(switchToDrawing) userInfo:nil repeats:NO];
        
    } else if ([self.touches count] == 2) {
        [self.timer invalidate];
        self.state = UIGestureRecognizerStateBegan;
        self.type = CustomGestureTypePanZoom;
        self.startPoint = self.midPoint;
        UITouch *touch1 = [self.touches objectAtIndex:0];
        UITouch *touch2 = [self.touches objectAtIndex:1];
        self.startDistance = [self distanceBetweenPoint:[touch1 locationInView:self.view] andPoint:[touch2 locationInView:self.view]];
    }
    
    [self processTouches];
}

- (float)scaleFactor
{
    UITouch *touch1 = [self.touches objectAtIndex:0];
    UITouch *touch2 = [self.touches objectAtIndex:1];
    
    float distance = [self distanceBetweenPoint:[touch1 locationInView:self.view] andPoint:[touch2 locationInView:self.view]];
    
    _scaleFactor *= distance/self.startDistance;
    
    return _scaleFactor;
}

- (float)distanceBetweenPoint:(CGPoint)point1 andPoint:(CGPoint)point2
{
    float dx = point1.x - point2.x;
    float dy = point1.y - point2.y;
    
    return sqrtf(dx*dx+dy*dy);
}

- (void)switchToDrawing
{
//    NSLog(@"Drawing detected");
    [self.delegate performSelector:@selector(startDrawing:) withObject:self];
    self.state = UIGestureRecognizerStateBegan;
    self.type = CustomGestureTypeDraw;
    [self processTouches];
}

- (CGPoint)point
{
    UITouch *touch = [self.touches objectAtIndex:0];
    return [touch locationInView:self.view];
}

- (CGPoint)midPoint
{
    if ([self.touches count] == 1) {
        return [[self.touches objectAtIndex:0] CGPointValue];
    }
    
    UITouch *touch1 = [self.touches objectAtIndex:0];
    UITouch *touch2 = [self.touches objectAtIndex:1];
    
    CGPoint point1 = [touch1 locationInView:self.view];
    CGPoint point2 = [touch2 locationInView:self.view];
    
    float dx = fabsf(point1.x - point2.x);
    float dy = fabsf(point1.y - point2.y);
    
    float midX = MIN(point1.x, point2.x) + dx * 0.5;
    float midY = MIN(point1.y, point2.y) + dy * 0.5;
    
    return CGPointMake(midX, midY);
}

- (void)removeTouches:(NSSet *)objects
{
    for (UITouch *oldTouch in objects) {
        if ([self.touches containsObject:oldTouch]) {
            [self.touches removeObject:oldTouch];
        }
    }
}

- (CGPoint)vectorOffset
{
    CGPoint point = self.midPoint;
    _vectorOffset =  CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
    
    return _vectorOffset;
}

- (void)processTouches
{
    [self.delegate performSelector:@selector(handleGesture:) withObject:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.touches count] == 1) {
        
        UITouch *touch = [self.touches objectAtIndex:0];
        
        if ([self distanceBetweenPoint:self.startPoint andPoint:[touch locationInView:self.view]] >= 20) {
            self.type = CustomGestureTypeDraw;
            self.state = UIGestureRecognizerStateBegan;
        }
    } else {
        
    }
    
    [self processTouches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.type == CustomGestureTypeUnknown
        && [self.touches count] == 1) {
        UITouch *touch = [self.touches objectAtIndex:0];
        CGPoint point = [touch locationInView:self.view];
        
        if ([self distanceBetweenPoint:point andPoint:self.startPoint] < 20) {
            self.type = CustomGestureTypeTap;
            self.state = UIGestureRecognizerStateRecognized;
            [self processTouches];
        }
    }
    
    
    self.state = UIGestureRecognizerStateEnded;
    [self reset];
}

@end
