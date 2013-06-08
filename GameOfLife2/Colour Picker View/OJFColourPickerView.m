//
//  OJFColourPickerView.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 20/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "OJFColourPickerView.h"

@implementation OJFColourPickerView


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
        self.minY = self.reticle.frame.size.height * 0.5;
        self.maxY = self.frame.size.height - self.reticle.frame.size.height * 0.5;
        self.minX = self.reticle.frame.size.width * 0.5;
        self.maxX = self.frame.size.width - self.reticle.frame.size.width * 0.5;
    }
    return self;
}

- (void)animateReticle
{
    float x = (self.maxX - self.minX) * self.saturation;
    float y = (self.maxY - self.minY) * (1 - self.value);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.reticle.center = CGPointMake(x, y);
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1)
    {
        UITouch *touch = [touches anyObject];
        
        CGPoint point = [touch locationInView:self];
        
        [self moveReticleToPoint:point];
        [self changeColorWithPoint:point];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1)
    {
        UITouch *touch = [touches anyObject];
        
        CGPoint point = [touch locationInView:self];
        
        [self moveReticleToPoint:point];
        [self changeColorWithPoint:point];
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
    
    float xValue = point.x;
    if (xValue < self.minX) {
        xValue = self.minX;
    }
    
    if (xValue > self.maxX) {
        xValue = self.maxX;
    }
    
    self.reticle.center = CGPointMake(xValue, yValue);
}

- (void)changeColorWithPoint:(CGPoint)point
{
    float yValue = point.y;
    if (yValue < self.minY) {
        yValue = self.minY;
    }
    
    if (yValue > self.maxY) {
        yValue = self.maxY;
    }
    
    float xValue = point.x;
    if (xValue < self.minX) {
        xValue = self.minX;
    }
    
    if (xValue > self.maxX) {
        xValue = self.maxX;
    }
    
    float value = 1 - (yValue - self.minY) / (self.maxY - self.minY);
    float saturation = (xValue - self.minX) / (self.maxX - self.minX);
    
    [self.delegate colourPickerDidChangeColour:CGPointMake(saturation, value)];
}

@end
