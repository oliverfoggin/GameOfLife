//
//  OJFCellMap.m
//  Game Of Life
//
//  Created by Oliver Foggin on 16/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OJFCellMap.h"

@implementation OJFCellMap

- (void)dealloc
{
    free(buffer);
    buffer = nil;
    free(cells);
    cells = nil;
    free(temp_cells);
    temp_cells = nil;
    free(changes);
    changes = nil;
    free(temp_changes);
    temp_changes = nil;
}

- (void)gridTouchesEnded
{
    touching = NO;
}

- (void)gridCellTouchedForX:(int)x andY:(int)y
{
    if (!touching)
    {
        self.editingOn = [self cellStateForX:x andY:y] != 1;
        touching = YES;
    }
    
    if (self.editingOn && [self cellStateForX:x andY:y] == 0)
        [self setCellWithX:x andY:y];
    
    if (!self.editingOn && [self cellStateForX:x andY:y] == 1)
        [self clearCellWithX:x andY:y];
    
    [self gridChanged];
}

- (void)initiliaseMap
{
    buffer = (GLubyte *) malloc(self.width * self.height * 4);
    provider = CGDataProviderCreateWithData(NULL, buffer, (self.width * self.height), NULL);
    
    length_in_bytes = self.width * self.height;
    
    cells = (unsigned char *)malloc(sizeof(unsigned char) * length_in_bytes);
    temp_cells = (unsigned char *)malloc(sizeof(unsigned char) * length_in_bytes);
    
    changes = (unsigned char *)malloc(sizeof(unsigned char) * length_in_bytes);
    temp_changes = (unsigned char *)malloc(sizeof(unsigned char) * length_in_bytes);
    
    self.population = 0;
    self.generation = 1;
    
    memset(cells, 0, sizeof(unsigned char) * length_in_bytes);
    memset(changes, 0, sizeof(unsigned char) * length_in_bytes);
}

- (void)gridChanged
{
    [self.delegate cellMapGenerationChanged:self.generation];
    [self.delegate cellMapPopulationChanged:self.population];
    [self.delegate gridChanged];
}

- (void)randomise
{
    unsigned int x, y;
    
    unsigned int seed = (unsigned) time(NULL);
    srand(seed);
    
    int state;
    
    self.generation = 1;
    
    for (y = 0; y < self.height; y ++)
        for (x = 0; x < self.width ; x ++)
        {
            state = random() % 2;
            
            if (state == 0) {
                if ([self cellStateForX:x andY:y] == 1) {
                    [self clearCellWithX:x andY:y];
                }
                else {
                    if ([self cellStateForX:x andY:y] == 0) {
                        [self setCellWithX:x andY:y];
                    }
                }
            }
        }
    
    [self gridChanged];
}

- (void)setPattern:(NSMutableSet*)points
              size:(CGSize)size
         fromCellX:(int)x
                 y:(int)y
{
    for (int i=x; i<x+size.width+2; i++) {
        for (int j=y; j<y+size.height+2; j++) {
            if ([self cellStateForX:i andY:j] == 1)
                [self clearCellWithX:i andY:j];
        }
    }
    
    for (NSValue *value in points) {
        CGPoint point = [value CGPointValue];
        if ([self cellStateForX:point.x + x andY:point.y + y] == 0)
        [self setCellWithX:point.x + x andY:point.y + y];
    }
    
    [self gridChanged];
}

- (void)clear
{
    self.generation = 1;
    
    for (int y = 0; y < self.height; y ++)
        for (int x = 0; x < self.width ; x ++)
        {
            if ([self cellStateForX:x andY:y] == 1)
                [self clearCellWithX:x andY:y];
        }
    
    [self gridChanged];
}

- (void)setSurvival:(BOOL)survive forNumber:(int)number
{
    survival[number] = survive;
}

- (void)setBirth:(BOOL)born forNumber:(int)number
{
    birth[number] = born;
}

- (void)checkAllCells
{
    length_in_bytes = self.width * self.height;
    memset(changes, 1, sizeof(unsigned char) * length_in_bytes);
}

- (void)setCellWithX:(int)x andY:(int)y
{
    unsigned int w = self.width, h = self.height;
    int xoleft, xoright, yoabove, yobelow;
    unsigned char *cell_ptr = cells + (y * w) + x;
    unsigned char *change_ptr = changes + (y * w) + x;
    BOOL wrapLeft, wrapRight, wrapUp, wrapDown;
    
    wrapUp = wrapRight = wrapLeft = wrapDown = NO;
    
    self.population++;
    
    if (x == 0)
    {
        wrapLeft = YES;
        xoleft = w - 1;
    }
    else
        xoleft = -1;
    
    if (y == 0)
    {
        wrapUp = YES;
        yoabove = length_in_bytes - w;
    }
    else
        yoabove = -w;
    
    if (x == (w - 1))
    {
        wrapRight = YES;
        xoright = -(w - 1);
    }
    else
        xoright = 1;
    
    if (y == (h - 1))
    {
        wrapDown = YES;
        yobelow = -(length_in_bytes - w);
    }
    else
        yobelow = w;
    
    *(cell_ptr) |= 0x01;
    *(change_ptr) |= 0x01;
    
    if (self.wrapEdges || !(wrapUp || wrapLeft))
    {
        *(cell_ptr + yoabove + xoleft) += 2;
        *(change_ptr + yoabove + xoleft) |= 0x01;
    }
    
    if (self.wrapEdges || !(wrapUp))
    {
        *(cell_ptr + yoabove) += 2;
        *(change_ptr + yoabove) |= 0x01;
    }
    
    if (self.wrapEdges || !(wrapUp || wrapRight))
    {
        *(cell_ptr + yoabove + xoright) += 2;
        *(change_ptr + yoabove + xoright) |= 0x01;
    }
    
    if (self.wrapEdges || !wrapLeft)
    {
        *(cell_ptr + xoleft) += 2;
        *(change_ptr + xoleft) |= 0x01;
    }
    
    if (self.wrapEdges || !wrapRight)
    {
        *(cell_ptr + xoright) += 2;
        *(change_ptr + xoright) |= 0x01;
    }
    
    if (self.wrapEdges || !(wrapDown || wrapLeft))
    {
        *(cell_ptr + yobelow + xoleft) += 2;
        *(change_ptr + yobelow + xoleft) |= 0x01;
    }
    
    if (self.wrapEdges || !wrapDown)
    {
        *(cell_ptr + yobelow) += 2;
        *(change_ptr + yobelow) |= 0x01;
    }
    
    if (self.wrapEdges || !(wrapDown || wrapRight))
    {
        *(cell_ptr + yobelow + xoright) += 2;
        *(change_ptr + yobelow + xoright) |= 0x01;
    }
}

- (void)clearCellWithX:(int)x andY:(int)y
{
    unsigned int w = self.width, h = self.height;
    int xoleft, xoright, yoabove, yobelow;
    unsigned char *cell_ptr = cells + (y * w) + x;
    unsigned char *change_ptr = changes + (y * w) + x;
    BOOL wrapLeft, wrapRight, wrapUp, wrapDown;
    
    wrapUp = wrapRight = wrapLeft = wrapDown = NO;
    
    self.population--;
    
    if (x == 0)
    {
        wrapLeft = YES;
        xoleft = w - 1;
    }
    else
        xoleft = -1;
    
    if (y == 0)
    {
        wrapUp = YES;
        yoabove = length_in_bytes - w;
    }
    else
        yoabove = -w;
    
    if (x == (w - 1))
    {
        wrapRight = YES;
        xoright = -(w - 1);
    }
    else
        xoright = 1;
    
    if (y == (h - 1))
    {
        wrapDown = YES;
        yobelow = -(length_in_bytes - w);
    }
    else
        yobelow = w;
    
    *(cell_ptr) &= ~0x01;
    *(change_ptr) |= 0x01;
    
    if (self.wrapEdges || !(wrapUp || wrapLeft))
    {
        *(cell_ptr + yoabove + xoleft) -= 2;
        *(change_ptr + yoabove + xoleft) |= 0x01;
    }
    
    if (self.wrapEdges || !wrapUp)
    {
        *(cell_ptr + yoabove) -= 2;
        *(change_ptr + yoabove) |= 0x01;
    }
    
    if (self.wrapEdges || !(wrapUp || wrapRight))
    {
        *(cell_ptr + yoabove + xoright) -= 2;
        *(change_ptr + yoabove + xoright) |= 0x01;
    }
    
    if (self.wrapEdges || !wrapLeft)
    {
        *(cell_ptr + xoleft) -= 2;
        *(change_ptr + xoleft) |= 0x01;
    }
    
    if (self.wrapEdges || !wrapRight)
    {
        *(cell_ptr + xoright) -= 2;
        *(change_ptr + xoright) |= 0x01;
    }
    
    if (self.wrapEdges || !(wrapDown || wrapLeft))
    {
        *(cell_ptr + yobelow + xoleft) -= 2;
        *(change_ptr + yobelow + xoleft) |= 0x01;
    }
    
    if (self.wrapEdges || !wrapDown)
    {
        *(cell_ptr + yobelow) -= 2;
        *(change_ptr + yobelow) |= 0x01;
    }
    
    if (self.wrapEdges || !(wrapDown || wrapRight))
    {
        *(cell_ptr + yobelow + xoright) -= 2;
        *(change_ptr + yobelow + xoright) |= 0x01;
    }
    
}

- (int)gridViewWantsStateForX:(int)x andY:(int)y
{
    return [self cellStateForX:x andY:y];
}

- (int)gridViewWidthFromX:(int)x andY:(int)y isAlive:(BOOL *)alive
{
    int returnWidth = 1;
    int findState = [self cellStateForX:x andY:y];
    
    if (findState == 1)
        *alive = YES;
    else
        *alive = NO;
    
    x++;
    
    while (x < self.width)
    {
        if ([self cellStateForX:x andY:y] == findState)
        {
            returnWidth++;
            x++;
        }
        else
        {
            return returnWidth;
        }
    }
    
    return returnWidth;
}

- (UIImage*)imageOfMapWithDeadColor:(UIColor *)deadColor aliveColor:(UIColor *)aliveColor
{
    //translate colours into rgb components
    if ([deadColor isEqual:[UIColor whiteColor]]) {
        dr = dg = db = 255;
    } else if ([deadColor isEqual:[UIColor blackColor]]) {
        dr = dg = db = 0;
    } else {
        [deadColor getRed:&drf green:&dgf blue:&dbf alpha:&blah];
        
        dr = drf * 255;
        dg = dgf * 255;
        db = dbf * 255;
    }
    
    if ([aliveColor isEqual:[UIColor whiteColor]]) {
        ar = ag = ab = 255;
    } else if ([aliveColor isEqual:[UIColor blackColor]]) {
        ar = ag = ab = 0;
    } else {
        [aliveColor getRed:&arf green:&agf blue:&abf alpha:&blah];
        
        ar = arf * 255;
        ag = agf * 255;
        ab = abf * 255;
    }
    
//    dr = 255, dg = 255, db = 255;
//    ar = 0, ag = 0, ab = 0;
    
    //create bytes of image from the cell map
    int yRef, cellRef;
    
    unsigned char *cell_ptr = cells;
    
    for (int y=0; y<self.height; y++)
    {
        yRef = y * (self.width * 4);
        
        int x = 0;
        do
        {
            cellRef = yRef + 4 * x;
            
            if (*cell_ptr & 0x01) {
                //alive colour
                buffer[cellRef] = ar;
                buffer[cellRef + 1] = ag;
                buffer[cellRef + 2] = ab;
                buffer[cellRef + 3] = 255;
            } else {
                //dead colour
                buffer[cellRef] = dr;
                buffer[cellRef + 1] = dg;
                buffer[cellRef + 2] = db;
                buffer[cellRef + 3] = 255;
            }
            cell_ptr++;
        } while (++x < self.width);
    }
    
    //create image
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    imageRef = CGImageCreate(self.width, self.height, 8, 32, 4 * self.width, colorSpace, kCGBitmapByteOrderDefault, provider, NULL, NO, kCGRenderingIntentDefault);
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    
    //return image
    return image;
}

- (int)cellStateForX:(int)x andY:(int)y
{
    unsigned int w = self.width;
    unsigned char *cell_ptr = cells + (y * w) + x;
    return *cell_ptr & 0x01;
}

- (void) nextGeneration
{
    unsigned int x, y, count;
    unsigned int h = self.height, w = self.width;
    
    memcpy(temp_cells, cells, length_in_bytes);
    memcpy(temp_changes, changes, length_in_bytes);
    memset(changes, 0, sizeof(unsigned char) * length_in_bytes);
    
    unsigned char *cell_ptr = temp_cells;
    unsigned char *change_ptr = temp_changes;
    
    self.generation++;
    
    for (y=0; y<h; y++)
    {
        BOOL EOL = NO;
        
        x = 0;
        do
        {
            if (!birth[0])
                while (*cell_ptr == 0)
                {
                    cell_ptr++;
                    change_ptr++;
                    if (++x >= w)
                    {
                        EOL = YES;
                        break;
                    }
                }
            
            if(EOL)
                break;
            
            if (*change_ptr != 0)
            {
                count = *cell_ptr >> 1;
                
                if (*cell_ptr & 0x01)
                {
                    if (!survival[count])
                        [self clearCellWithX:x andY:y];
                }
                else
                {
                    if (birth[count])
                        [self setCellWithX:x andY:y];
                }
            }
            
            cell_ptr++;
            change_ptr++;
            
        } while (++x < w);
    }
    
    [self gridChanged];
}

@end
