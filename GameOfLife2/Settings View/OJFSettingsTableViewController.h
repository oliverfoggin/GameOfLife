//
//  OJFSettingsTableViewController.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 22/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LifeSetting;

@protocol OJFSettingsViewDelegate <NSObject>

- (void)settingsChangedWithSurvival:(NSArray*)survival
                              birth:(NSArray*)birth;

@end

@interface OJFSettingsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong) id<OJFSettingsViewDelegate> delegate;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)addButtonPressed;

@end
