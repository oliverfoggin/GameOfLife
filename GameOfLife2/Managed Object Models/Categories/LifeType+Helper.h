//
//  LifeType+Helper.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 25/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "LifeType.h"

@interface LifeType (Helper)

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context allowDelete:(BOOL)allowDelete name:(NSString*)name;

+ (LifeType*)lifeTypeWithAllowDelete:(BOOL)allowDelete;

@end
