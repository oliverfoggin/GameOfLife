//
//  LifeType+Helper.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 25/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "LifeType+Helper.h"
#import "OJFAppDelegate.h"

@implementation LifeType (Helper)

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context allowDelete:(BOOL)allowDelete name:(NSString*)name
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    
    if (self != nil) {
        self.name = name;
        self.allowDelete = [NSNumber numberWithBool:allowDelete];
    }
    return self;
}

+ (LifeType*)lifeTypeWithAllowDelete:(BOOL)allowDelete
{
    NSManagedObjectContext *context = [(OJFAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LifeType"];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"allowDelete = %@", @(allowDelete)]];
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    
    if ([results count] > 0) {
        return results[0];
    }
    
    return nil;
}

@end
