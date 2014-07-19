//
//  SCContactTableViewCell.h
//  SitCircles
//
//  Created by B.J. Ray on 6/28/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCContact.h"

@interface SCContactTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) SCContact *contact;
@property (weak, nonatomic) IBOutlet UILabel *primaryPhoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;


@end
