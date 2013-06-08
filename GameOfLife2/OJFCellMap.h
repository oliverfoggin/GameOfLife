//
//  OJFCellMap.h
//  Game Of Life
//
//  Created by Oliver Foggin on 16/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OJFGridView.h"

@protocol OJFCellMapDelegate <NSObject>

- (void)cellMapGenerationChanged:(int)generation;
- (void)cellMapPopulationChanged:(int)population;
- (void)gridChanged;

@end

@interface OJFCellMap : NSObject <OJFGridViewDelegate>
{
    unsigned int length_in_bytes;
    unsigned char *cells;
    unsigned char *temp_cells;
    unsigned char *changes;
    unsigned char *temp_changes;
    GLubyte *buffer;
    CGImageRef imageRef;
    CGDataProviderRef provider;
    BOOL survival[9];
    BOOL birth[9];
    BOOL touching;
    int ar, ag, ab, dr, dg, db;
    float arf, agf, abf, drf, dgf, dbf, blah;
}

@property (nonatomic) BOOL editingOn;
@property (nonatomic) unsigned int width;
@property (nonatomic) unsigned int height;
@property UIImage *mapImage;
@property (nonatomic) BOOL wrapEdges;
@property (nonatomic) unsigned int population;
@property (nonatomic) unsigned int generation;
@property (nonatomic, strong) id <OJFCellMapDelegate> delegate;

- (void)setSurvival:(BOOL)survive forNumber:(int)number;
- (void)setBirth:(BOOL)born forNumber:(int)number;

- (void)initiliaseMap;
- (void)randomise;
- (void)setPattern:(NSMutableSet*)points
              size:(CGSize)size
         fromCellX:(int)x
                 y:(int)y;
- (void)clear;
- (void)setCellWithX:(int)x andY:(int)y;
- (void)clearCellWithX:(int)x andY:(int)y;
- (int)cellStateForX:(int)x andY:(int)y;

- (void)nextGeneration;
- (void)gridChanged;

- (void)checkAllCells;

@end