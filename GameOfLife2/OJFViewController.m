//
//  OJFViewController.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 10/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "OJFViewController.h"
#import "OJFGridLineView.h"
#import "OJFGestureRecogniser.h"
#import "Condition+Helper.h"
#import "OJFColourPickerViewController.h"
#import "OJFSettingsTableViewController.h"
#import "OJFPatternViewController.h"
#import "OJFAboutViewController.h"
#import "OJFPatternSelectViewController.h"

@interface OJFViewController () <PatternViewDelegate, PatternSelectorDelegate>

@property (nonatomic, strong) OJFPatternViewController *patternViewController;
@property BOOL addingPattern;

@end

@implementation OJFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.mapHeight = 64;
    self.mapWidth = 5 + [[UIScreen mainScreen] bounds].size.height * 2 / 10;
    
    self.cellmap = [[OJFCellMap alloc] init];
    self.cellmap.width = self.mapWidth;
    self.cellmap.height = self.mapHeight;
    self.cellmap.delegate = self;
    self.cellmap.wrapEdges = YES;
    [self.cellmap initiliaseMap];
    
    self.survival = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        if (i == 2 || i == 3) {
            [self.cellmap setSurvival:YES forNumber:i];
        }
        else {
            [self.cellmap setSurvival:NO forNumber:i];
        }
    }
    
    self.birth = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        if (i == 3) {
            [self.cellmap setBirth:YES forNumber:i];
        }
        else {
            [self.cellmap setBirth:NO forNumber:i];
        }
    }
    
    self.aliveColor = [UIColor blackColor];
    self.deadColor = [UIColor whiteColor];
    
    self.gridView.aliveColor = self.aliveColor;
    self.gridView.deadColor = self.deadColor;
    self.gridView.mapwidth = self.mapWidth;
    self.gridView.mapheight = self.mapHeight;
    self.gridView.delegate = self.cellmap;
    self.gridView.magnification = 10;
    self.gridView.frame = CGRectMake(0, 0, self.mapWidth * 10, self.mapHeight * 10);
    self.gridView.center = self.view.center;
    self.gridView.image.frame = CGRectMake(0, 0, self.gridView.frame.size.width, self.gridView.frame.size.height);
    
    self.lineView.mapheight = self.mapHeight;
    self.lineView.mapwidth = self.mapWidth;
    self.lineView.magnification = 10;
    self.lineView.frame = CGRectMake(0, 0, self.gridView.frame.size.width, self.gridView.frame.size.height);
    
    [self.cellmap gridChanged];
    
    OJFGestureRecogniser *recogniser = [[OJFGestureRecogniser alloc] init];
    recogniser.delegate = self;
    [self.gridView addGestureRecognizer:recogniser];
    
    self.stepSpeed = 0.1;
    
    CGAffineTransform sliderTransform = CGAffineTransformMakeRotation(M_PI * 1.5);
    self.speedSlider.transform = sliderTransform;
    
    self.minZoom = 0.5;
    self.maxZoom = 5.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.gridView gridChanged];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    self.playPauseView.center = CGPointMake(self.view.center.x, self.view.frame.size.height - self.playPauseView.frame.size.height * 0.5);
    
    self.settingsView.center = CGPointMake(self.view.frame.size.width - self.settingsView.frame.size.width * 0.5, self.view.center.y);
    
    self.speedView.center = CGPointMake(self.speedView.frame.size.width * 0.5, self.view.center.y);
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

- (void)startDrawing:(OJFGestureRecogniser *)recogniser
{
    CGPoint point = recogniser.startPoint;
    
    if ([self.cellmap cellStateForX:point.x * 0.1 andY:point.y * 0.1] == 0) {
        self.cellmap.editingOn = YES;
    } else {
        self.cellmap.editingOn = NO;
    }
}

#pragma mark - gesture recognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (!self.addingPattern) {
        return YES;
    }
    
    CGPoint touchPoint = [touch locationInView:self.gridView];
    CGRect patternFrame = self.patternViewController.view.frame;
    
    if (CGRectContainsPoint(patternFrame, touchPoint)) {
        return NO;
    }
    
    return YES;
}

- (void)handleGesture:(OJFGestureRecogniser *)recognizer
{
    float scale;
    CGPoint offset;
    
    switch (recognizer.type) {
        case CustomGestureTypeDraw:
            if (self.addingPattern) {
                return;
            }
            [self.gridView touchedAtPointX:recognizer.point.x Y:recognizer.point.y];
            break;
        case CustomGestureTypePanZoom:
            scale = recognizer.scaleFactor;
            offset = recognizer.vectorOffset;
            
            if (scale < self.minZoom) {
                scale = self.minZoom;
                recognizer.scaleFactor = self.minZoom;
            }
            
            if (scale > self.maxZoom) {
                scale = self.maxZoom;
                recognizer.scaleFactor = self.maxZoom;
            }
            
            [self.gridView setTransform:CGAffineTransformMakeScale(scale, scale)];
            
            float x = self.gridView.center.x + offset.x;
            float y = self.gridView.center.y + offset.y;
            
            if (x > self.gridView.frame.size.width * 0.5) {
                x = self.gridView.frame.size.width * 0.5;
            }
            
            if (x < self.view.frame.size.width - self.gridView.frame.size.width * 0.5) {
                x = self.view.frame.size.width - self.gridView.frame.size.width * 0.5;
            }
            
            if (y > self.gridView.frame.size.height * 0.5) {
                y = self.gridView.frame.size.height * 0.5;
            }
            
            if (y < self.view.frame.size.height - self.gridView.frame.size.height * 0.5) {
                y = self.view.frame.size.height - self.gridView.frame.size.height * 0.5;
            }
            
            self.gridView.center = CGPointMake(x, y);
            
            break;
        case CustomGestureTypeTap:
            if (self.addingPattern) {
                return;
            }
            [self.gridView touchedAtPointX:recognizer.startPoint.x Y:recognizer.startPoint.y];
            break;
            
        default:
            break;
    }
}

#pragma mark - animations

- (void)animateViewsOut:(BOOL)includePayPauseView
{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         if (includePayPauseView)
                         {
                             self.playPauseView.transform = CGAffineTransformMakeTranslation(0, self.playPauseView.frame.size.height);
                         }
                         
                         self.settingsView.transform = CGAffineTransformMakeTranslation(self.settingsView.frame.size.width, 0);
                         self.speedView.transform = CGAffineTransformMakeTranslation(-self.speedView.frame.size.width, 0);
                     } completion:nil];
}

- (void)animateViewsIn
{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.playPauseView.transform = CGAffineTransformIdentity;
                         self.settingsView.transform = CGAffineTransformIdentity;
                         self.speedView.transform = CGAffineTransformIdentity;
                     } completion:nil];
}
#pragma mark - UIFunctions

- (IBAction)aboutButtonPressed:(id)sender {
    OJFAboutViewController *controller = [[OJFAboutViewController alloc] initWithNibName:@"OJFAboutViewController" bundle:nil];
    
    [self.navigationController pushViewController:controller animated:YES];
}


- (IBAction)playPauseButtonPressed:(id)sender {
    if (self.playPauseButton.selected) {
        [self pause];
    }
    else {
        [self play];
    }
}

- (IBAction)stepButtonPressed:(id)sender {
    [self.cellmap nextGeneration];
}

- (void)play
{
    self.playPauseButton.selected = YES;
    [self animateViewsOut:NO];
    self.stepTimer = [NSTimer scheduledTimerWithTimeInterval:self.stepSpeed target:self.cellmap selector:@selector(nextGeneration) userInfo:nil repeats:YES];
}

- (void)pause
{
    self.playPauseButton.selected = NO;
    [self animateViewsIn];
    [self.stepTimer invalidate];
}

- (IBAction)speedSliderChanged:(id)sender {
    self.stepSpeed = 1 / self.speedSlider.value;
}

- (IBAction)randomButtonPressed:(id)sender {
    [self.cellmap randomise];
}

- (IBAction)clearButtonPressed:(id)sender {
    [self.cellmap clear];
}

- (IBAction)wrapEdgesButtonPressed:(id)sender {
    [self.cellmap clear];
    self.wrapEdgesButton.selected = !self.wrapEdgesButton.selected;
    self.cellmap.wrapEdges = self.wrapEdgesButton.selected;
}

- (IBAction)colourButtonPressed:(id)sender {
    OJFColourPickerViewController *colourPicker = [[OJFColourPickerViewController alloc] initWithNibName:@"OJFColourPickerViewController" bundle:nil];
    
    colourPicker.aliveColor = self.aliveColor;
    colourPicker.deadColor = self.deadColor;
    colourPicker.delegate = self;
    
    [self.navigationController pushViewController:colourPicker animated:YES];
}

- (IBAction)settingsButtonPressed:(id)sender {
    OJFSettingsTableViewController *settingsController = [[OJFSettingsTableViewController alloc] initWithNibName:@"OJFSettingsTableViewController" bundle:nil];
    
    settingsController.delegate = self;
    
    [self.navigationController pushViewController:settingsController animated:YES];
}

#pragma mark - Cell Map Delegate

- (void)gridChanged
{
    [self.gridView gridChanged];
}

- (void)cellMapGenerationChanged:(int)generation
{
}

- (void)cellMapPopulationChanged:(int)population
{
    
}

#pragma mark - colour control delegate

- (void)colorPickerDidChangeAliveColor:(UIColor *)aliveColor
{
    self.aliveColor = aliveColor;
    self.gridView.aliveColor = self.aliveColor;
}

- (void)colorPickerDidChangeDeadColor:(UIColor *)deadColor
{
    self.deadColor = deadColor;
    self.gridView.deadColor = self.deadColor;
}

#pragma mark - settings delegate

- (void)settingsChangedWithSurvival:(NSArray *)survival birth:(NSArray *)birth
{
    [self.cellmap checkAllCells];
    
    for (int i=0; i<9; i++) {
        
        if ([survival containsObject:[Condition conditionWithNeighbours:i]]) {
            [self.cellmap setSurvival:YES forNumber:i];
        } else {
            [self.cellmap setSurvival:NO forNumber:i];
        }
    }
    
    for (int i=0; i<9; i++) {
        
        if ([birth containsObject:[Condition conditionWithNeighbours:i]]) {
            [self.cellmap setBirth:YES forNumber:i];
        } else {
            [self.cellmap setBirth:NO forNumber:i];
        }
    }
}

#pragma mark - Pattern view delegate

- (IBAction)patternsButtonPressed:(id)sender {
    OJFPatternSelectViewController *controller = [[OJFPatternSelectViewController alloc] initWithNibName:@"OJFPatternSelectViewController" bundle:nil];
    
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)patternSelectorDidSelectPatternString:(NSString *)patternString
{
//    self.patternViewController.patternString = @"1,2:2,1:3,1:3,2:3,3";
//    self.patternViewController.patternString = @"1,5:1,6:2,5:2,6:11,5:11,6:11,7:12,4:12,8:13,3:13,9:14,3:14,9:15,6:16,4:16,8:17,5:17,6:17,7:18,6:21,3:21,4:21,5:22,3:22,4:22,5:23,2:23,6:25,1:25,2:25,6:25,7:35,3:35,4:36,3:36,4";
    
    CGPoint center = [self.view convertPoint:self.view.center toView:self.gridView];
    
    self.patternViewController.patternString = patternString;
    [self.patternViewController displayView];
    self.patternViewController.position = center;
    self.patternViewController.view.hidden = NO;
    
    [self animateViewsOut:YES];
    
    self.addingPattern = YES;
}

- (OJFPatternViewController*)patternViewController
{
    if (_patternViewController == nil) {
        _patternViewController = [[OJFPatternViewController alloc] initWithNibName:@"OJFPatternViewController" bundle:nil];
        
        _patternViewController.cellSize = 10;
        _patternViewController.view.hidden = YES;
        _patternViewController.delegate = self;
        
        [self.lineView addSubview:_patternViewController.view];
    }
    
    return _patternViewController;
}

- (void)patternDidConfirmPosition
{
    CGPoint cell = [self.gridView cellForPoint:CGPointMake(self.patternViewController.position.x + 20 + 5, self.patternViewController.position.y + 20 + 5)];
    
    [self.cellmap setPattern:self.patternViewController.points size:self.patternViewController.size fromCellX:cell.x y:cell.y];
    self.patternViewController.view.hidden = YES;
    
    [self animateViewsIn];
    
    self.addingPattern = NO;
}

@end
