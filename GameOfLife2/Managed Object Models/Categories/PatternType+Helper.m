//
//  PatternType+Helper.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 25/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "PatternType+Helper.h"

@implementation PatternType (Helper)

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context allowDelete:(BOOL)allowDelete name:(NSString*)name
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    
    if (self != nil) {
        self.name = name;
        self.allowDelete = [NSNumber numberWithBool:allowDelete];
    }
    return self;
}


@end
