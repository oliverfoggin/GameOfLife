//
//  Condition+Helper.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 25/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "Condition.h"

@interface Condition (Helper)

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context neighbours:(int)neighbours;

+ (Condition*)conditionWithNeighbours:(int)neighbours;

@end
