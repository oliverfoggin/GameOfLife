//
//  OJFGestureRecogniser.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 13/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

typedef enum {
    CustomGestureTypeTap,
    CustomGestureTypeDraw,
    CustomGestureTypePanZoom,
    CustomGestureTypeUnknown
} CustomGestureType;

@interface OJFGestureRecogniser : UIGestureRecognizer

@property (nonatomic) CustomGestureType type;

@property (strong) UITouch *firstTouch;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint vectorOffset;
@property (nonatomic) float scaleFactor;
@property (nonatomic) CGPoint midPoint;
@property (nonatomic) CGPoint point;

@end
