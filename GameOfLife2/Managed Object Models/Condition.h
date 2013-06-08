//
//  Condition.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 22/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LifeSetting;

@interface Condition : NSManagedObject

@property (nonatomic, retain) NSNumber * neighbours;
@property (nonatomic, retain) NSSet *settingBirth;
@property (nonatomic, retain) NSSet *settingSurvival;
@end

@interface Condition (CoreDataGeneratedAccessors)

- (void)addSettingBirthObject:(LifeSetting *)value;
- (void)removeSettingBirthObject:(LifeSetting *)value;
- (void)addSettingBirth:(NSSet *)values;
- (void)removeSettingBirth:(NSSet *)values;

- (void)addSettingSurvivalObject:(LifeSetting *)value;
- (void)removeSettingSurvivalObject:(LifeSetting *)value;
- (void)addSettingSurvival:(NSSet *)values;
- (void)removeSettingSurvival:(NSSet *)values;

@end
