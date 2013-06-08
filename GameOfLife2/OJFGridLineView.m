//
//  OJFGridLineView.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 12/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "OJFGridLineView.h"

@implementation OJFGridLineView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIBezierPath*)gridLines
{
    if (_gridLines) {
        return _gridLines;
    }
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    for (int x = 0; x <= self.mapwidth; x ++)
    {
        [path moveToPoint:CGPointMake(x * self.magnification, 0)];
        [path addLineToPoint:CGPointMake(x * self.magnification, self.mapheight * self.magnification)];
    }
    
    for (int y = 0; y <= self.mapheight; y ++)
    {
        [path moveToPoint:CGPointMake(0, y * self.magnification)];
        [path addLineToPoint:CGPointMake(self.mapwidth * self.magnification, y * self.magnification)];
    }
    
    path.lineWidth = 1;
    
    _gridLines = path;
    
    return _gridLines;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesBegan:touches withEvent:event];
//    [self resignFirstResponder];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesEnded:touches withEvent:event];
//    [self resignFirstResponder];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesMoved:touches withEvent:event];
//    [self resignFirstResponder];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesCancelled:touches withEvent:event];
//    [self resignFirstResponder];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [[UIColor blackColor] set];
    [self.gridLines stroke];
}

@end
