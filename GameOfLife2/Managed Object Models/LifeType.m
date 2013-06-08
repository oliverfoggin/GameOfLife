//
//  LifeType.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 23/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "LifeType.h"
//#import "LifeSetting.h"
//#import "OJFAppDelegate.h"

@implementation LifeType

@dynamic name;
@dynamic allowDelete;
@dynamic lifeSettings;

//+ (LifeType*)initWithName:(NSString *)name
//              allowDelete:(BOOL)allowDelete
//{
//    OJFAppDelegate *delegate = (OJFAppDelegate*)[[UIApplication sharedApplication] delegate];
//    
//    NSManagedObjectContext *context = [delegate managedObjectContext];
//    
//    LifeType *lifeType = [NSEntityDescription insertNewObjectForEntityForName:@"LifeType" inManagedObjectContext:context];
//    
//    lifeType.name = name;
//    lifeType.allowDelete = @(allowDelete);
//    
//    [delegate saveContext];
//    
//    return lifeType;
//}
//
//+ (LifeType*)lifeType:(BOOL)allowDelete
//{
//    OJFAppDelegate *delegate = (OJFAppDelegate*)[[UIApplication sharedApplication] delegate];
//    
//    NSManagedObjectContext *context = [delegate managedObjectContext];
//    
//    NSEntityDescription *lifeTypeEntity = [NSEntityDescription entityForName:@"LifeType" inManagedObjectContext:context];
//    
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:lifeTypeEntity];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"allowDelete = %@", @(allowDelete)];
//    [request setPredicate:predicate];
//    
//    NSArray *results = [context executeFetchRequest:request error:nil];
//    
//    if ([results count] > 0) {
//        return [results objectAtIndex:0];
//    }
//    
//    return nil;
//}

@end
