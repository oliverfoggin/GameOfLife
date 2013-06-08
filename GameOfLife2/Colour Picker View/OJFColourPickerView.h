//
//  OJFColourPickerView.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 20/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OJFColourPickerDelegate <NSObject>

- (void)colourPickerDidChangeColour:(CGPoint)satValPoint;

@end

@interface OJFColourPickerView : UIView

@property (strong) id<OJFColourPickerDelegate> delegate;
@property float minX;
@property float minY;
@property float maxX;
@property float maxY;
@property (nonatomic) float saturation;
@property (nonatomic) float value;
@property (weak) IBOutlet UIImageView *reticle;

- (void)animateReticle;

@end
