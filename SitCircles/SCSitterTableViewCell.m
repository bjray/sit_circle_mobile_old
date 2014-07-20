//
//  SCSitterTableViewCell.m
//  SitCircles
//
//  Created by B.J. Ray on 7/20/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCSitterTableViewCell.h"

@interface SCSitterTableViewCell()
@property (nonatomic, retain) UIImageView *cellSeperator;
@property (nonatomic, retain) UIImageView *badge;

@end

@implementation SCSitterTableViewCell

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


- (void)setSitter:(SCSitter *)sitter {
    _sitter = sitter;
    self.nameLabel.text = sitter.fullName;
    if (sitter.primaryNumberValue) {
        self.primaryPhoneLabel.text = sitter.primaryNumberValue;
    }
    if (sitter.image) {
        self.sitterImageView.image = sitter.image;
    }
}

- (void)setSitterImageView:(UIImageView *)sitterImageView {
    _sitterImageView = sitterImageView;
    _sitterImageView.layer.borderWidth = 1.0f;
    _sitterImageView.layer.borderColor = [UIColor grayColor].CGColor;
    _sitterImageView.layer.masksToBounds = NO;
    _sitterImageView.clipsToBounds = YES;
    _sitterImageView.contentMode = UIViewContentModeScaleAspectFill;
    _sitterImageView.layer.cornerRadius = 35;
    }
@end
