//
//  LifeSetting.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 23/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Condition, LifeType;

@interface LifeSetting : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *birthConditions;
@property (nonatomic, retain) NSSet *survivalConditions;
@property (nonatomic, retain) LifeType *type;
@end

@interface LifeSetting (CoreDataGeneratedAccessors)

- (void)addBirthConditionsObject:(Condition *)value;
- (void)removeBirthConditionsObject:(Condition *)value;
- (void)addBirthConditions:(NSSet *)values;
- (void)removeBirthConditions:(NSSet *)values;

- (void)addSurvivalConditionsObject:(Condition *)value;
- (void)removeSurvivalConditionsObject:(Condition *)value;
- (void)addSurvivalConditions:(NSSet *)values;
- (void)removeSurvivalConditions:(NSSet *)values;

@end
