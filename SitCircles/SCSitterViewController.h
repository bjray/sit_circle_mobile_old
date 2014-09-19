//
//  SCSitterViewController.h
//  SitCircles
//
//  Created by B.J. Ray on 6/22/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCSitter.h"

@interface SCSitterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *sitterImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *primaryPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *primaryEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *blurredImageView;

@property (strong, nonatomic) SCSitter *sitter;
@end
