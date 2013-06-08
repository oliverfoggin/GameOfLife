//
//  Condition+Helper.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 25/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "Condition+Helper.h"
#import "OJFAppDelegate.h"

@implementation Condition (Helper)

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context neighbours:(int)neighbours
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    
    if (self != nil) {
        self.neighbours = [NSNumber numberWithInt:neighbours];
    }
    return self;
}

+ (Condition*)conditionWithNeighbours:(int)neighbours
{
    NSManagedObjectContext *context = [(OJFAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Condition"];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"neighbours = %i", neighbours]];
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    
    if ([results count] > 0) {
        return results[0];
    }
    
    return [[Condition alloc] initWithEntity:[NSEntityDescription entityForName:@"Condition" inManagedObjectContext:context] insertIntoManagedObjectContext:context neighbours:neighbours];
}

@end
