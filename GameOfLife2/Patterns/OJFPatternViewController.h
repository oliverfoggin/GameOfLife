//
//  OJFPatternViewController.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 22/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OJFPatternViewController;

@protocol PatternViewDelegate <NSObject>

- (void)patternDidConfirmPosition;

@end

@interface OJFPatternViewController : UIViewController

@property id <PatternViewDelegate> delegate;

@property (nonatomic) CGPoint position;
@property (nonatomic) NSString *patternString;
@property NSMutableSet *points;

@property CGSize size;
@property int cellSize;

- (IBAction)tickButtonPressed:(id)sender;
- (IBAction)gestureRecognizerDidAction:(id)sender;
- (void)displayView;

@end
