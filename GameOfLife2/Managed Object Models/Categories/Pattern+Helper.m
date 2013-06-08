//
//  Pattern+Helper.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 25/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "Pattern+Helper.h"

@implementation Pattern (Helper)

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context name:(NSString*)name notes:(NSString*)notes patternString:(NSString*)patternString
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    
    if (self != nil) {
        self.name = name;
        self.notes = notes;
        self.patternString = patternString;
    }
    return self;
}

@end
