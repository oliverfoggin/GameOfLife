//
//  OJFPatternSelectViewController.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 23/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PatternSelectorDelegate <NSObject>

- (void)patternSelectorDidSelectPatternString:(NSString*)patternString;

@end

@interface OJFPatternSelectViewController : UITableViewController

@property (nonatomic, weak) id <PatternSelectorDelegate> delegate;

@end
