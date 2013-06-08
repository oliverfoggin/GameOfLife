//
//  Pattern+Helper.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 25/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "Pattern.h"

@interface Pattern (Helper)

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context name:(NSString*)name notes:(NSString*)notes patternString:(NSString*)patternString;

@end
