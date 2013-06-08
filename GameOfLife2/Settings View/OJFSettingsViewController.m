//
//  OJFSettingsViewController.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 21/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "OJFSettingsViewController.h"
#import "LifeSetting+Helper.h"
#import "Condition+Helper.h"
#import "LifeType+Helper.h"
#import "OJFAppDelegate.h"

@interface OJFSettingsViewController ()

@property NSManagedObjectContext *context;

@end

@implementation OJFSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [(OJFAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[self.delegate settingsChangedWithSurvival:self.survival birth:self.birth];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.title = @"New Setting";
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    self.survival = [NSMutableArray arrayWithCapacity:9];
    self.birth = [NSMutableArray arrayWithCapacity:9];
    
    for (int i = 0; i < 9; i++) {
        [self.survival addObject:@(NO)];
        [self.birth addObject:@(NO)];
    }
    
    for (UIButton *button in self.survivalButtons) {
        int i = button.tag;
        
        [button setSelected:[[self.survival objectAtIndex:i] boolValue]];
    }
    
    for (UIButton *button in self.birthButtons) {
        int i = button.tag;
        
        [button setSelected:[[self.birth objectAtIndex:i] boolValue]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"tableSegue"]) {
//        OJFSettingsTableViewController *controller = segue.destinationViewController;
    }
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

- (IBAction)survivalButtonPressed:(id)sender {
    UIButton *button = (UIButton*)sender;
    
    int i = [button.titleLabel.text intValue];
    
    BOOL current = [[self.survival objectAtIndex:i] boolValue];
    
    [button setSelected:!current];
    
    [self.survival replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!current]];
}

- (IBAction)birthButtonPressed:(id)sender {
    UIButton *button = (UIButton*)sender;
    
    int i = [button.titleLabel.text intValue];
    
    BOOL current = [[self.birth objectAtIndex:i] boolValue];
    
    [button setSelected:!current];
    
    [self.birth replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!current]];
}

- (IBAction)saveButtonPressed:(id)sender {
    if ([_nameField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please give your setting a name" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    } else {
        LifeType *lifeType = [LifeType lifeTypeWithAllowDelete:YES];
        
        NSMutableArray *saveSurvival = [NSMutableArray array];
        
        int i = 0;
        
        for (NSNumber *value in self.survival) {
            if ([value boolValue]) {
                [saveSurvival addObject:@(i)];
            }
            i++;
        }
        
        NSMutableArray *saveBirth = [NSMutableArray array];
        
        i = 0;
        
        for (NSNumber *value in self.birth) {
            if ([value boolValue]) {
                [saveBirth addObject:@(i)];
            }
            i++;
        }
        
        if ([saveBirth count] == 0
            || [saveSurvival count] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please select at least one birth and survival setting" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
            return;
        } else {
            
            [lifeType addLifeSettingsObject:[[LifeSetting alloc] initWithEntity:[NSEntityDescription entityForName:@"LifeSetting" inManagedObjectContext:self.context] insertIntoManagedObjectContext:self.context name:self.nameField.text birthConditions:saveBirth survivalConditions:saveSurvival]];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)settingsTableDidSelectLifeSetting:(LifeSetting *)lifeSetting
{
    for (UIButton *button in _survivalButtons) {
        int i = [button.titleLabel.text intValue];
        
        if ([lifeSetting.survivalConditions containsObject:[Condition conditionWithNeighbours:i]]) {
            button.selected = YES;
            [self.survival replaceObjectAtIndex:i withObject:@(YES)];
        } else {
            button.selected = NO;
            [self.survival replaceObjectAtIndex:i withObject:@(NO)];
        }
    }
    
    for (UIButton *button in _birthButtons) {
        int i = [button.titleLabel.text intValue];
        
        if ([lifeSetting.birthConditions containsObject:[Condition conditionWithNeighbours:i]]) {
            button.selected = YES;
            [self.birth replaceObjectAtIndex:i withObject:@(YES)];
        } else {
            button.selected = NO;
            [self.birth replaceObjectAtIndex:i withObject:@(NO)];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidUnload {
    [self setNameField:nil];
    [super viewDidUnload];
}
@end
