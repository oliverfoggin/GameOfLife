//
//  PatternType.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 23/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pattern;

@interface PatternType : NSManagedObject

@property (nonatomic, retain) NSNumber * allowDelete;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *patterns;
@end

@interface PatternType (CoreDataGeneratedAccessors)

- (void)addPatternsObject:(Pattern *)value;
- (void)removePatternsObject:(Pattern *)value;
- (void)addPatterns:(NSSet *)values;
- (void)removePatterns:(NSSet *)values;

//+ (PatternType*)initWithName:(NSString *)name
//                 allowDelete:(BOOL)allowDelete;
//
//+ (PatternType*)patternType:(BOOL)allowDelete;

@end
