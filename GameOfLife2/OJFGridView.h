//
//  OJFGridView.h
//  Game Of Life
//
//  Created by Oliver Foggin on 29/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OJFGridViewDelegate <NSObject>

- (void)gridCellTouchedForX:(int)x andY:(int)y;
- (void)gridTouchesEnded;
- (int)gridViewWidthFromX:(int)x andY:(int)y isAlive:(BOOL*)alive;
- (UIImage*)imageOfMapWithDeadColor:(UIColor*)deadColor aliveColor:(UIColor*)aliveColor;

@end

@interface OJFGridView : UIView
{
    int xTouchedCell, yTouchedCell;
    int initialX, initialY, currentX, currentY;
}

@property (nonatomic, strong) UIColor* aliveColor;
@property (nonatomic, strong) UIColor* deadColor;
@property (nonatomic) int mapwidth;
@property (nonatomic) int mapheight;
@property (nonatomic) int magnification;
@property (nonatomic, strong) id <OJFGridViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIImageView *image;

- (void)gridChanged;

- (void)touchedAtPointX:(int)x Y:(int)y;

- (CGPoint)cellForPoint:(CGPoint)point;

@end
