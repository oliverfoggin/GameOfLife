//
//  OJFPatternCell.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 25/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "OJFPatternCell.h"
#import "UIImage+PatternString.h"
#import <QuartzCore/QuartzCore.h>

@interface OJFPatternCell ()

@property (nonatomic, weak) IBOutlet UIImageView *patternView;
@property (nonatomic) CGSize maxImageSize;
@property (nonatomic, strong) NSLayoutConstraint *imageWidthConstraint;

@end

@implementation OJFPatternCell

- (void)awakeFromNib
{
    self.patternView.layer.magnificationFilter = kCAFilterNearest;
    self.patternView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)layoutSubviews
{
    float width = self.frame.size.width;
    
    self.patternView.frame = CGRectMake(width - self.patternView.frame.size.width, self.patternView.frame.origin.y, self.patternView.frame.size.width, self.patternView.frame.size.height);
    self.notesLabel.frame = CGRectMake(20, self.notesLabel.frame.origin.y, width - 50 - self.patternView.frame.size.width, self.notesLabel.frame.size.height);
    self.nameLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y, width - 40, self.nameLabel.frame.size.height);
}

- (void)setPatternString:(NSString *)patternString
{
    _patternString = patternString;
    
    UIImage *patternImage = [UIImage imageFromPatternString:patternString];
    
    self.patternView.image = patternImage;
}

@end
