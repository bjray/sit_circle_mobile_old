//
//  SCContactTableViewCell.m
//  SitCircles
//
//  Created by B.J. Ray on 6/28/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCContactTableViewCell.h"

@implementation SCContactTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
