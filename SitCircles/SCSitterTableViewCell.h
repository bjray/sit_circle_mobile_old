//
//  SCSitterTableViewCell.h
//  SitCircles
//
//  Created by B.J. Ray on 7/20/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCSitter.h"

@interface SCSitterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) SCSitter *sitter;
@property (weak, nonatomic) IBOutlet UILabel *primaryPhoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sitterImageView;

@end
