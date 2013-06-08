//
//  OJFSettingsTableViewController.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 22/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "OJFSettingsTableViewController.h"
#import "OJFAppDelegate.h"
#import "LifeSetting.h"
#import "LifeType.h"
#import "Condition.h"
#import "OJFSettingsViewController.h"

@interface OJFSettingsTableViewController ()

@end

@implementation OJFSettingsTableViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _managedObjectContext = [(OJFAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"Settings";
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)addButtonPressed
{
    OJFSettingsViewController *controller = [[OJFSettingsViewController alloc] initWithNibName:@"OJFSettingsViewController" bundle:nil];
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController*)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSEntityDescription *lifeEntity = [NSEntityDescription entityForName:@"LifeSetting" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:lifeEntity];
    
    [request setFetchBatchSize:20];
    
    NSSortDescriptor *sdType = [[NSSortDescriptor alloc] initWithKey:@"type.name" ascending:YES];
    NSSortDescriptor *sdName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sdType, sdName];
    [request setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                                managedObjectContext:self.managedObjectContext
                                                                                                  sectionNameKeyPath:@"type.name"
                                                                                                           cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fetchedResultsController;
}

#pragma mark - Fetched Results Controller Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationRight];
            break;
            
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self tableView:self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - UI Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        float largeWidth = (self.tableView.frame.size.width - 40) * 0.55;
        float smallWidth = (self.tableView.frame.size.width - 40) * 0.45;
        
        float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, largeWidth, height)];
        nameLabel.numberOfLines = 1;
        nameLabel.font = [UIFont boldSystemFontOfSize:20];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.tag = 1;
        
        UILabel *birthLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width - 20 - smallWidth, 0, smallWidth, height * 0.5)];
        birthLabel.textAlignment = NSTextAlignmentRight;
        birthLabel.numberOfLines = 1;
        birthLabel.font = [UIFont systemFontOfSize:14];
        birthLabel.backgroundColor = [UIColor clearColor];
        birthLabel.tag = 2;
        
        UILabel *survivalLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width - 20 - smallWidth, height * 0.5, smallWidth, height * 0.5)];
        survivalLabel.textAlignment = NSTextAlignmentRight;
        survivalLabel.numberOfLines = 1;
        survivalLabel.font = [UIFont systemFontOfSize:14];
        survivalLabel.backgroundColor = [UIColor clearColor];
        survivalLabel.tag = 3;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:birthLabel];
        [cell.contentView addSubview:survivalLabel];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    UILabel *nameLabel = (UILabel*)[cell.contentView viewWithTag:1];
    UILabel *birthLabel = (UILabel*)[cell.contentView viewWithTag:2];
    UILabel *survivalLabel = (UILabel*)[cell.contentView viewWithTag:3];
    
    LifeSetting *lifeSetting = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"neighbours" ascending:YES];
    
    NSArray *birthSettings = [[lifeSetting.birthConditions allObjects] sortedArrayUsingDescriptors:@[sd]];
    
    NSMutableString *birthString = [NSMutableString string];
    
    for (Condition *birthSetting in birthSettings) {
        if ([birthString isEqualToString:@""]) {
            [birthString appendFormat:@"Birth Settings: %@", birthSetting.neighbours];
        } else {
            [birthString appendFormat:@", %@", birthSetting.neighbours];
        }
    }
    
    NSArray *survivalSettings = [[lifeSetting.survivalConditions allObjects] sortedArrayUsingDescriptors:@[sd]];
    
    NSMutableString *survivalString = [NSMutableString string];
    
    for (Condition *survivalSetting in survivalSettings) {
        if ([survivalString isEqualToString:@""]) {
            [survivalString appendFormat:@"Survival Settings: %@", survivalSetting.neighbours];
        } else {
            [survivalString appendFormat:@", %@", survivalSetting.neighbours];
        }
    }
    
    [nameLabel setText:lifeSetting.name];
    [birthLabel setText:birthString];
    [survivalLabel setText:survivalString];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    LifeSetting *lifeSetting = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    return [lifeSetting.type.allowDelete boolValue];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    LifeSetting *lifeSetting = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        OJFAppDelegate *delegate = (OJFAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        NSManagedObjectContext *context = [delegate managedObjectContext];
        
        [context deleteObject:lifeSetting];
        
        [delegate saveContext];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LifeSetting *lifeSetting = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self.delegate settingsChangedWithSurvival:[lifeSetting.survivalConditions allObjects] birth:[lifeSetting.birthConditions allObjects]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
