//
//  OJFPatternCell.h
//  GameOfLife2
//
//  Created by Oliver Foggin on 25/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OJFPatternCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *notesLabel;

@property (nonatomic, strong) NSString *patternString;

@end
