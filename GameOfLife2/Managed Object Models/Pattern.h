//
//  Pattern.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 23/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PatternType;

@interface Pattern : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * patternString;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) PatternType *patternType;

//+ (Pattern*)initWithName:(NSString*)name
//                    type:(PatternType*)type
//                   notes:(NSString*)notes
//           patternString:(NSString*)patternString;

@end
