//
//  LifeSetting+Helper.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 25/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "LifeSetting+Helper.h"
#import "Condition+Helper.h"
#import "OJFAppDelegate.h"

@implementation LifeSetting (Helper)

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context name:(NSString*)name birthConditions:(NSArray*)birthConditions survivalConditions:(NSArray*)survivalConditions
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    
    if (self != nil) {
        self.name = name;
        
        NSEntityDescription *conditionEntity = [NSEntityDescription entityForName:@"Condition" inManagedObjectContext:context];
        
        NSFetchRequest *conditionFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Condition"];
        
        for (NSNumber *number in birthConditions) {
            [conditionFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"neighbours = %@", number]];
            
            NSArray *conditions = [context executeFetchRequest:conditionFetchRequest error:nil];
            
            Condition *condition;
            
            if ([conditions count] == 0) {
                condition = [[Condition alloc] initWithEntity:conditionEntity insertIntoManagedObjectContext:context neighbours:[number intValue]];
            } else {
                condition = conditions[0];
            }
            
            [self addBirthConditionsObject:condition];
        }
        
        for (NSNumber *number in survivalConditions) {
            [conditionFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"neighbours = %@", number]];
            
            NSArray *conditions = [context executeFetchRequest:conditionFetchRequest error:nil];
            
            Condition *condition;
            
            if ([conditions count] == 0) {
                condition = [[Condition alloc] initWithEntity:conditionEntity insertIntoManagedObjectContext:context neighbours:[number intValue]];
            } else {
                condition = conditions[0];
            }
            
            [self addSurvivalConditionsObject:condition];
        }
    }
    return self;
}


@end
