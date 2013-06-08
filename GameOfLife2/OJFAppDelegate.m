//
//  OJFAppDelegate.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 10/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "OJFAppDelegate.h"
#import "LifeSetting+Helper.h"
#import "LifeType+Helper.h"
#import "OJFViewController.h"
#import "Pattern+Helper.h"
#import "PatternType+Helper.h"

@implementation OJFAppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self addDefaultData];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.rootViewController = [[OJFViewController alloc] initWithNibName:@"OJFViewController" bundle:nil];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - core data functions

- (void)addDefaultData
{
    NSFetchRequest *patternRequest = [[NSFetchRequest alloc] initWithEntityName:@"PatternType"];
    
    NSEntityDescription *patterntypeEntity = [NSEntityDescription entityForName:@"PatternType" inManagedObjectContext:self.managedObjectContext];
    
    PatternType *presetPatternType, *userPatternType;
    
    [patternRequest setPredicate:[NSPredicate predicateWithFormat:@"allowDelete = NO"]];
    
    NSArray *patterns = [self.managedObjectContext executeFetchRequest:patternRequest error:nil];
    
    if ([patterns count] == 0) {
        presetPatternType = [[PatternType alloc] initWithEntity:patterntypeEntity insertIntoManagedObjectContext:self.managedObjectContext allowDelete:NO name:@"Predefined Patterns"];
    } else {
        presetPatternType = patterns[0];
    }
    
    [patternRequest setPredicate:[NSPredicate predicateWithFormat:@"allowDelete = YES"]];
    
    patterns = [self.managedObjectContext executeFetchRequest:patternRequest error:nil];
    
    if ([patterns count] == 0) {
        userPatternType = [[PatternType alloc] initWithEntity:patterntypeEntity insertIntoManagedObjectContext:self.managedObjectContext allowDelete:YES name:@"User Patterns"];
    } else {
        userPatternType = patterns[0];
    }
    
    NSEntityDescription *patternEntity = [NSEntityDescription entityForName:@"Pattern" inManagedObjectContext:self.managedObjectContext];
    
    if ([presetPatternType.patterns count] == 0) {
        
        [presetPatternType addPatternsObject:[[Pattern alloc] initWithEntity:patternEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"Conway's Glider" notes:@"Simple Glider with Conway's Game of Life settings" patternString:@"1,2:2,1:3,1:3,2:3,3"]];
        
        [presetPatternType addPatternsObject:[[Pattern alloc] initWithEntity:patternEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"2x2 Glider" notes:@"Simple Glider with 2x2 settings" patternString:@"1,1:1,2:1,3:3,3:3,5:4,2"]];
        
        [presetPatternType addPatternsObject:[[Pattern alloc] initWithEntity:patternEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"2x2 puffer" notes:@"Puffer pattern with 2x2 settings" patternString:@"1,4:1,5:1,6:3,2:3,6:3,8:4,1:4,5"]];
        
        [presetPatternType addPatternsObject:[[Pattern alloc] initWithEntity:patternEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"Glider Gun" notes:@"Conway's Game of Life produces Conway's Gliders" patternString:@"1,5:1,6:2,5:2,6:11,5:11,6:11,7:12,4:12,8:13,3:13,9:14,3:14,9:15,6:16,4:16,8:17,5:17,6:17,7:18,6:21,3:21,4:21,5:22,3:22,4:22,5:23,2:23,6:25,1:25,2:25,6:25,7:35,3:35,4:36,3:36,4"]];
        
        [presetPatternType addPatternsObject:[[Pattern alloc] initWithEntity:patternEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"Lightweight Spaceship" notes:@"Spaceship pattern with Conway's Game of Life" patternString:@"1,2:1,4:2,1:3,1:4,1:4,4:5,1:5,2:5,3"]];

        [presetPatternType addPatternsObject:[[Pattern alloc] initWithEntity:patternEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"Blinker" notes:@"Conway's Game of Life simple repeater" patternString:@"1,1:1,2:1,3"]];

        [presetPatternType addPatternsObject:[[Pattern alloc] initWithEntity:patternEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"Toad" notes:@"Conway's Game of Life simple repeater" patternString:@"1,2:2,1:2,2:3,1:3,2:4,1"]];
        
        [presetPatternType addPatternsObject:[[Pattern alloc] initWithEntity:patternEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"Beacon" notes:@"Conway's Game of Life simple repeater" patternString:@"1,1:1,2:2,1:2,2:3,3:3,4:4,3:4,4"]];

        [presetPatternType addPatternsObject:[[Pattern alloc] initWithEntity:patternEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"Pulsar" notes:@"Conway's Game of Life complex repeater" patternString:@"1,3:1,4:1,5:1,9:1,10:1,11:3,1:3,6:3,8:3,13:4,1:4,6:4,8:4,13:5,1:5,6:5,8:5,13:6,3:6,4:6,5:6,9:6,10:6,11:8,3:8,4:8,5:8,9:8,10:8,11:9,1:9,6:9,8:9,13:10,1:10,6:10,8:10,13:11,1:11,6:11,8:11,13:13,3:13,4:13,5:13,9:13,10:13,11"]];

        [presetPatternType addPatternsObject:[[Pattern alloc] initWithEntity:patternEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"Space Rake" notes:@"Moves forward while producing Conway's Gliders with Conway's Game of Life setting" patternString:@"1,18:1,20:2,17:3,17:4,17:4,20:5,17:5,18:5,19:8,8:9,7:9,9:10,6:10,7:10,9:10,10:11,2:11,3:11,9:11,10:12,2:12,3:12,4:12,9:12,10:13,1:13,3:13,4:13,9:13,10:13,11:14,1:14,2:14,3:15,2:17,10:18,8:18,9:18,10:18,11:19,2:19,4:19,7:19,11:19,16:19,18:20,1:20,7:20,10:20,15:21,1:21,8:21,9:21,10:21,15:22,1:22,4:22,15:22,18:23,1:23,2:23,3:23,15:23,16:23,17"]];
        
        [presetPatternType addPatternsObject:[[Pattern alloc] initWithEntity:patternEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"Puffer Train" notes:@"Moves forward and leaves a trail of debris behind with Conway's Game of Life setting" patternString:@"1,2:1,3:1,4:1,16:1,17:1,18:2,1:2,4:2,15:2,18:3,4:3,9:3,10:3,11:3,18:4,4:4,9:4,12:4,18:5,3:5,8:5,17"]];
    }
    
    NSFetchRequest *typeRequest = [NSFetchRequest fetchRequestWithEntityName:@"LifeType"];
    
    [typeRequest setPredicate:[NSPredicate predicateWithFormat:@"allowDelete = NO"]];
    
    NSArray *typeResults = [self.managedObjectContext executeFetchRequest:typeRequest error:nil];
    
    LifeType *type;
    
    if ([typeResults count] == 0) {
        NSEntityDescription *typeEntity = [NSEntityDescription entityForName:@"LifeType" inManagedObjectContext:self.managedObjectContext];
        
        type = [[LifeType alloc] initWithEntity:typeEntity insertIntoManagedObjectContext:self.managedObjectContext allowDelete:NO name:@"Predefined Settings"];
        
        (void)[[LifeType alloc] initWithEntity:typeEntity insertIntoManagedObjectContext:self.managedObjectContext allowDelete:YES name:@"User Settings"];
    } else {
        type = typeResults[0];
    }
    
    if ([type.lifeSettings count] == 0) {
        
        NSEntityDescription *settingEntity = [NSEntityDescription entityForName:@"LifeSetting" inManagedObjectContext:self.managedObjectContext];
        
        [type addLifeSettingsObject:[[LifeSetting alloc] initWithEntity:settingEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"Conway's Game of Life" birthConditions:@[@3] survivalConditions:@[@2, @3]]];
        
        [type addLifeSettingsObject:[[LifeSetting alloc] initWithEntity:settingEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"Vote" birthConditions:@[@5, @6, @7, @8] survivalConditions:@[@4, @5, @6, @7, @8]]];
        
        [type addLifeSettingsObject:[[LifeSetting alloc] initWithEntity:settingEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"Walled Cities" birthConditions:@[@4, @5, @6, @7, @8] survivalConditions:@[@2, @3, @4, @5]]];
        
        [type addLifeSettingsObject:[[LifeSetting alloc] initWithEntity:settingEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"Maze" birthConditions:@[@3] survivalConditions:@[@1, @2, @3, @4, @5]]];
        
        [type addLifeSettingsObject:[[LifeSetting alloc] initWithEntity:settingEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"34 Life" birthConditions:@[@3, @4] survivalConditions:@[@3, @4]]];
        
        [type addLifeSettingsObject:[[LifeSetting alloc] initWithEntity:settingEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"Coral" birthConditions:@[@3] survivalConditions:@[@4, @5, @6, @7, @8]]];
        
        [type addLifeSettingsObject:[[LifeSetting alloc] initWithEntity:settingEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"2x2" birthConditions:@[@3, @6] survivalConditions:@[@1, @2, @5]]];
        
        [type addLifeSettingsObject:[[LifeSetting alloc] initWithEntity:settingEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"Move" birthConditions:@[@3, @6, @8] survivalConditions:@[@2, @4, @5]]];
        
        [type addLifeSettingsObject:[[LifeSetting alloc] initWithEntity:settingEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"Dry Life" birthConditions:@[@3, @7] survivalConditions:@[@2, @3]]];
        
        [type addLifeSettingsObject:[[LifeSetting alloc] initWithEntity:settingEntity insertIntoManagedObjectContext:self.managedObjectContext name:@"Coagulations" birthConditions:@[@3, @7, @8] survivalConditions:@[@2, @3, @5, @6, @7, @8]]];
    }
    
    [self saveContext];
}

- (void)mergeChanges:(NSNotification *)notification
{
    [self.managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:) withObject:notification waitUntilDone:NO];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GameOfLife" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GameOfLife.sqlite"];
    
//    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES};
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @(YES),
          NSInferMappingModelAutomaticallyOption: @(YES)};
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
