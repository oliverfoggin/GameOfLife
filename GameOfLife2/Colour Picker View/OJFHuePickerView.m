//
//  OJFHuePickerView.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 20/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "OJFHuePickerView.h"

@implementation OJFHuePickerView


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
        self.minY = self.reticle.frame.size.height * 0.5;
        self.maxY = self.frame.size.height - self.reticle.frame.size.height * 0.5;
    }
    return self;
}

- (void)setHue:(float)hue
{
    float y = (self.maxY - self.minY) * hue;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.reticle.center = CGPointMake(self.reticle.center.x, y);
    }];
    
    _hue = hue;
    [self.delegate huePickerDidAnimateReticle:hue];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1)
    {
        UITouch *touch = [touches anyObject];
        
        CGPoint point = [touch locationInView:self];
        
        [self moveReticleToPoint:point];
        [self changeHueWithPoint:point];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1)
    {
        UITouch *touch = [touches anyObject];
        
        CGPoint point = [touch locationInView:self];
        
        [self moveReticleToPoint:point];
        [self changeHueWithPoint:point];
    }
}

- (void)moveReticleToPoint:(CGPoint)point
{
    float yValue = point.y;
    if (yValue < self.minY) {
        yValue = self.minY;
    }
    
    if (yValue > self.maxY) {
        yValue = self.maxY;
    }
    
    self.reticle.center = CGPointMake(self.reticle.center.x, yValue);
}

- (void)changeHueWithPoint:(CGPoint)point
{
    float yValue = point.y;
    if (yValue < self.minY) {
        yValue = self.minY;
    }
    
    if (yValue > self.maxY) {
        yValue = self.maxY;
    }
    
    self.hue = (yValue - self.minY) / (self.maxY - self.minY);
    [self.delegate huePickerDidChangeHue:self.hue];
}

@end
