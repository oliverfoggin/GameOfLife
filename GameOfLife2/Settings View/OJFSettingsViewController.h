//
//  OJFSettingsViewController.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 21/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OJFSettingsTableViewController.h"

@interface OJFSettingsViewController : UIViewController <UITextFieldDelegate>

@property (strong) NSMutableArray *survival;
@property (strong) NSMutableArray *birth;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *survivalButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *birthButtons;
@property (strong, nonatomic) IBOutlet UITextField *nameField;

- (IBAction)survivalButtonPressed:(id)sender;
- (IBAction)birthButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end
