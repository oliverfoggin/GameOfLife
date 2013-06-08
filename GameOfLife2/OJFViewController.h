//
//  OJFViewController.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 10/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OJFCellMap.h"
#import "OJFGridLineView.h"
#import "OJFColourPickerViewController.h"
#import "OJFSettingsTableViewController.h"

@interface OJFViewController : UIViewController <OJFCellMapDelegate, UIScrollViewDelegate, OJFColourControlDelegate, OJFSettingsViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) int mapWidth;
@property (nonatomic) int mapHeight;

@property float minZoom;
@property float maxZoom;

@property (strong, nonatomic) IBOutlet UISlider *speedSlider;
@property (strong, nonatomic) OJFCellMap *cellmap;
@property (nonatomic) float stepSpeed;
@property (nonatomic, strong) NSTimer *stepTimer;

@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) IBOutlet UIButton *wrapEdgesButton;

@property (strong, nonatomic) IBOutlet OJFGridView *gridView;
@property (strong, nonatomic) IBOutlet OJFGridLineView *lineView;
@property (nonatomic, strong) UIColor *aliveColor;
@property (nonatomic, strong) UIColor *deadColor;

@property (nonatomic, strong) NSMutableArray *survival;
@property (nonatomic, strong) NSMutableArray *birth;

@property (strong, nonatomic) IBOutlet UIView *speedView;
@property (strong, nonatomic) IBOutlet UIView *settingsView;
@property (strong, nonatomic) IBOutlet UIView *playPauseView;

- (IBAction)aboutButtonPressed:(id)sender;
- (IBAction)playPauseButtonPressed:(id)sender;
- (IBAction)stepButtonPressed:(id)sender;
- (void)play;
- (void)pause;

- (IBAction)speedSliderChanged:(id)sender;
- (IBAction)randomButtonPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;
- (IBAction)wrapEdgesButtonPressed:(id)sender;
- (IBAction)colourButtonPressed:(id)sender;
- (IBAction)settingsButtonPressed:(id)sender;
- (IBAction)patternsButtonPressed:(id)sender;

@end
