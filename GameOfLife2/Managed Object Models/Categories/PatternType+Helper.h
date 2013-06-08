//
//  PatternType+Helper.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 25/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "PatternType.h"

@interface PatternType (Helper)

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context allowDelete:(BOOL)allowDelete name:(NSString*)name;

@end
