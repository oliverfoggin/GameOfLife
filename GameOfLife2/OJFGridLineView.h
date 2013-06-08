//
//  OJFGridLineView.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 12/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OJFGridLineView : UIView

@property (nonatomic, strong) UIBezierPath *gridLines;
@property (nonatomic) int mapwidth;
@property (nonatomic) int mapheight;
@property (nonatomic) int magnification;

@end
