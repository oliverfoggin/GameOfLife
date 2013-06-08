//
//  Pattern.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 23/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "Pattern.h"
//#import "OJFAppDelegate.h"

@implementation Pattern

@dynamic name;
@dynamic patternString;
@dynamic patternType;
@dynamic notes;

//+ (Pattern*)initWithName:(NSString*)name
//                    type:(PatternType*)type
//                   notes:(NSString*)notes
//           patternString:(NSString*)patternString
//{
//    OJFAppDelegate *delegate = (OJFAppDelegate*)[[UIApplication sharedApplication] delegate];
//    
//    NSManagedObjectContext *context = [delegate managedObjectContext];
//    
//    Pattern *pattern = [NSEntityDescription insertNewObjectForEntityForName:@"Pattern" inManagedObjectContext:context];
//    
//    pattern.patternType = type;
//    pattern.name = name;
//    pattern.notes = notes;
//    pattern.patternString = patternString;
//    
//    [delegate saveContext];
//    
//    return pattern;
//}

@end
