//
//  OJFColourPickerViewController.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 20/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "OJFColourPickerViewController.h"
#import "UIColor-HSVAdditions.h"
#import <QuartzCore/QuartzCore.h>

@interface OJFColourPickerViewController ()

@end

@implementation OJFColourPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.hue = [self.aliveColor hue];
    self.saturation = [self.aliveColor saturation];
    self.value = [self.aliveColor value];
    
    self.colourPicker.frame = CGRectMake(180, 20, 280, 280);
    
    self.huePicker.delegate = self;
    self.colourPicker.delegate = self;
    
    self.huePicker.hue = self.hue;
    self.colourPicker.saturation = self.saturation;
    self.colourPicker.value = self.value;
    
    self.selectedButton = @"alive";
    
    self.aliveButton.layer.cornerRadius = 8;
    self.aliveButton.layer.masksToBounds = YES;
    self.aliveButton.layer.borderWidth = 2;
    self.aliveButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.aliveButton.backgroundColor = self.aliveColor;
    
    self.deadButton.layer.cornerRadius = 8;
    self.deadButton.layer.masksToBounds = YES;
    self.deadButton.layer.borderWidth = 0;
    self.deadButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.deadButton.backgroundColor = self.deadColor;
    
    [self.colourPicker animateReticle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft
            || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - huepicker delegate

- (void)huePickerDidChangeHue:(float)hue
{
    self.hue = hue;
    self.colourPicker.backgroundColor = [UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1];
    
    [self updateColourButtons];
}

- (void)huePickerDidAnimateReticle:(float)hue
{
    self.colourPicker.backgroundColor = [UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1];
}

- (void)colourPickerDidChangeColour:(CGPoint)satValPoint
{
    self.saturation = satValPoint.x;
    self.value = satValPoint.y;
    
    [self updateColourButtons];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)aliveButtonPressed:(id)sender {
    self.selectedButton = @"alive";
    self.aliveButton.layer.borderWidth = 2;
    self.deadButton.layer.borderWidth = 0;
    [self updateControlsWithColour:self.aliveColor];
}

- (IBAction)deadButtonPressed:(id)sender {
    self.selectedButton = @"dead";
    self.aliveButton.layer.borderWidth = 0;
    self.deadButton.layer.borderWidth = 2;
    [self updateControlsWithColour:self.deadColor];
}

- (void)updateColourButtons
{
    if ([self.selectedButton isEqualToString:@"alive"]) {
        self.aliveColor = [UIColor colorWithHue:self.hue saturation:self.saturation brightness:self.value alpha:1];
        self.aliveButton.backgroundColor = self.aliveColor;
        [self.delegate colorPickerDidChangeAliveColor:self.aliveColor];
    } else {
        self.deadColor = [UIColor colorWithHue:self.hue saturation:self.saturation brightness:self.value alpha:1];
        self.deadButton.backgroundColor = self.deadColor;
        [self.delegate colorPickerDidChangeDeadColor:self.deadColor];
    }
}

- (void)updateControlsWithColour:(UIColor*)color
{
    self.hue = [color hue];
    self.saturation = [color saturation];
    self.value = [color value];
    
    self.huePicker.hue = self.hue;
    self.colourPicker.saturation = self.saturation;
    self.colourPicker.value = self.value;
    [self.colourPicker animateReticle];
}

@end
