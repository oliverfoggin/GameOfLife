//
//  OJFHuePickerView.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 20/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OJFHuePickerDelegate <NSObject>

- (void)huePickerDidChangeHue:(float)hue;
- (void)huePickerDidAnimateReticle:(float)hue;

@end

@interface OJFHuePickerView : UIView

@property (nonatomic) float hue;
@property (strong) id<OJFHuePickerDelegate> delegate;
@property (weak) IBOutlet UIImageView *reticle;
@property float maxY;
@property float minY;

@end
