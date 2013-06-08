//
//  OJFColourPickerViewController.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 20/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OJFColourPickerView.h"
#import "OJFHuePickerView.h"

@protocol OJFColourControlDelegate <NSObject>

- (void)colorPickerDidChangeDeadColor:(UIColor*)deadColor;
- (void)colorPickerDidChangeAliveColor:(UIColor*)aliveColor;

@end

@interface OJFColourPickerViewController : UIViewController <OJFHuePickerDelegate, OJFColourPickerDelegate>

@property (strong) id<OJFColourControlDelegate> delegate;

@property (strong, nonatomic) IBOutlet OJFColourPickerView *colourPicker;
@property (strong, nonatomic) IBOutlet OJFHuePickerView *huePicker;
@property (strong, nonatomic) IBOutlet UIButton *aliveButton;
@property (strong, nonatomic) IBOutlet UIButton *deadButton;

@property float hue;
@property float saturation;
@property float value;
@property (strong) UIColor *aliveColor;
@property (strong) UIColor *deadColor;
@property (strong) NSString *selectedButton;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)aliveButtonPressed:(id)sender;
- (IBAction)deadButtonPressed:(id)sender;

@end
