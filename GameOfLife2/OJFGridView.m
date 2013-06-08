//
//  OJFGridView.m
//  Game Of Life
//
//  Created by Oliver Foggin on 29/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OJFGridView.h"
#import <QuartzCore/QuartzCore.h>

@implementation OJFGridView

- (void)awakeFromNib
{
    self.image.layer.magnificationFilter = kCAFilterNearest;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)gridChanged
{
    self.image.image = [self.delegate imageOfMapWithDeadColor:self.deadColor aliveColor:self.aliveColor];
}

- (CGPoint)cellForPoint:(CGPoint)point
{
    CGPoint cell = CGPointMake(((int)point.x - ((int)point.x % self.magnification))/ self.magnification, ((int)point.y - ((int)point.y % self.magnification))/ self.magnification);
    
    return cell;
}

- (void)touchedAtPointX:(int)x Y:(int)y
{
    
    xTouchedCell = ((int)x - ((int)x % self.magnification))/ self.magnification;
    yTouchedCell = ((int)y - ((int)y % self.magnification))/ self.magnification;
    
    [self.delegate gridCellTouchedForX:xTouchedCell andY:yTouchedCell];
}

@end
