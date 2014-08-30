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
        NSLog(@"SCContactTableViewCell was called!");
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

- (void)setContact:(SCContact *)contact {
    _contact = contact;
    self.nameLabel.text = contact.fullName;
    if (contact.primaryNumberValue) {
        self.primaryPhoneLabel.text = [NSString stringWithFormat:@"%@: %@",contact.primaryNumberLabel, contact.primaryNumberValue ];
        
    } else {
        self.primaryPhoneLabel.text = @"no number found...";
    }
    if (contact.imageData) {
        self.contactImageView.image = [UIImage imageWithData:contact.imageData];
    }
    if (contact.isLocked) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)setContactImageView:(UIImageView *)contactImageView {
    _contactImageView = contactImageView;
    _contactImageView.layer.borderWidth = 1.0f;
    _contactImageView.layer.borderColor = [UIColor grayColor].CGColor;
    _contactImageView.layer.masksToBounds = NO;
    _contactImageView.clipsToBounds = YES;
    _contactImageView.contentMode = UIViewContentModeScaleAspectFill;
    _contactImageView.layer.cornerRadius = 30;
}

@end
