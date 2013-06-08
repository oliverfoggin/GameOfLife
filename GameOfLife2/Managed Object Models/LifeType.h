//
//  LifeType.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 23/07/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LifeSetting;

@interface LifeType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * allowDelete;
@property (nonatomic, retain) NSSet *lifeSettings;
@end

@interface LifeType (CoreDataGeneratedAccessors)

- (void)addLifeSettingsObject:(LifeSetting *)value;
- (void)removeLifeSettingsObject:(LifeSetting *)value;
- (void)addLifeSettings:(NSSet *)values;
- (void)removeLifeSettings:(NSSet *)values;

//+ (LifeType*)initWithName:(NSString*)name
//              allowDelete:(BOOL)allowDelete;
//
//+ (LifeType*)lifeType:(BOOL)allowDelete;

@end
