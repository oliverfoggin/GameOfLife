//
//  OJFAppDelegate.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 10/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OJFViewController;

@interface OJFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property OJFViewController *rootViewController;
@property UINavigationController *navigationController;

- (void)mergeChanges:(NSNotification*)notification;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)addDefaultData;

@end
