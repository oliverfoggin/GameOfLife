//
//  PatternType.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 23/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "PatternType.h"
//#import "Pattern.h"
//#import "OJFAppDelegate.h"

@implementation PatternType

@dynamic allowDelete;
@dynamic name;
@dynamic patterns;

//+ (PatternType*)initWithName:(NSString *)name
//              allowDelete:(BOOL)allowDelete
//{
//    OJFAppDelegate *delegate = (OJFAppDelegate*)[[UIApplication sharedApplication] delegate];
//    
//    NSManagedObjectContext *context = [delegate managedObjectContext];
//    
//    PatternType *patternType = [NSEntityDescription insertNewObjectForEntityForName:@"PatternType" inManagedObjectContext:context];
//    
//    patternType.name = name;
//    patternType.allowDelete = @(allowDelete);
//    
//    [delegate saveContext];
//    
//    return patternType;
//}
//
//+ (PatternType*)patternType:(BOOL)allowDelete
//{
//    OJFAppDelegate *delegate = (OJFAppDelegate*)[[UIApplication sharedApplication] delegate];
//    
//    NSManagedObjectContext *context = [delegate managedObjectContext];
//    
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"PatternType"];
//    
//    [request setPredicate:[NSPredicate predicateWithFormat:@"allowDelete = %@", @(allowDelete)]];
//    
//    NSArray *results = [context executeFetchRequest:request error:nil];
//    
//    if ([results count] > 0) {
//        return results[0];
//    }
//    
//    return nil;
//}

@end
