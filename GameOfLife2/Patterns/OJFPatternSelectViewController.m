//
//  OJFPatternSelectViewController.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 23/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "OJFPatternSelectViewController.h"
#import "OJFAppDelegate.h"
#import "Pattern.h"
#import "OJFPatternCell.h"

@interface OJFPatternSelectViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UINib *patternCellNib;

@end

@implementation OJFPatternSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [(OJFAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.patternCellNib = [UINib nibWithNibName:@"OJFPatternCell" bundle:nil];
    [self.tableView registerNib:self.patternCellNib forCellReuseIdentifier:@"PatternCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"Patterns";
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - fetched results controller

- (NSFetchedResultsController*)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSEntityDescription *lifeEntity = [NSEntityDescription entityForName:@"Pattern" inManagedObjectContext:self.context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:lifeEntity];
    
    [request setFetchBatchSize:20];
    
    NSSortDescriptor *sdType = [[NSSortDescriptor alloc] initWithKey:@"patternType.name" ascending:YES];
    NSSortDescriptor *sdName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sdType, sdName];
    [request setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:@"patternType.name" cacheName:@"AllPatterns"];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fetchedResultsController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    
    return [sectionInfo numberOfObjects];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    
    return [sectionInfo name];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 137.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PatternCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self configureCell:(OJFPatternCell*)cell atIndexPath:indexPath];
    // Configure the cell...
    
    return cell;
}

- (void)configureCell:(OJFPatternCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    Pattern *pattern = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.patternString = pattern.patternString;
    cell.nameLabel.text = pattern.name;
    cell.notesLabel.text = pattern.notes;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Pattern *pattern = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self.delegate patternSelectorDidSelectPatternString:pattern.patternString];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
