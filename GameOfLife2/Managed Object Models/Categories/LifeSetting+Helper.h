//
//  LifeSetting+Helper.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 25/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "LifeSetting.h"

@interface LifeSetting (Helper)

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context name:(NSString*)name birthConditions:(NSArray*)birthConditions survivalConditions:(NSArray*)survivalConditions;

@end
