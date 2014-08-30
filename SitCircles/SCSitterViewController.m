//
//  SCSitterViewController.m
//  SitCircles
//
//  Created by B.J. Ray on 6/22/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCSitterViewController.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import "SCPhoneNumber.h"
#import "SCEmailAddress.h"

@interface SCSitterViewController ()

@end

@implementation SCSitterViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        NSLog(@"Init method fired...");
        
    }
    
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.backgroundImageView.image = self.sitter.image;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 1;
    [self.blurredImageView setImageToBlur:self.sitter.image blurRadius:10.0 completionBlock:nil];
    self.blurredImageView.clipsToBounds = YES;
    
    self.sitterImageView.image = self.sitter.image;
    self.sitterImageView.layer.borderWidth = 0.5f;
    self.sitterImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.sitterImageView.layer.masksToBounds = NO;
    self.sitterImageView.clipsToBounds = YES;
    self.sitterImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.sitterImageView.layer.cornerRadius = 65;

    self.nameLabel.text = self.sitter.fullName;
    SCPhoneNumber *primaryPhone = self.sitter.primaryPhone;
    SCEmailAddress *primaryEmail = self.sitter.primaryEmail;
    
    self.primaryPhoneLabel.text = primaryPhone ? primaryPhone.value : @"No phone";
    self.primaryEmailLabel.text = primaryEmail ? primaryEmail.value : @"No email";
    self.phoneCountLabel.text = [self phoneCountLabelForSitter:self.sitter];
    self.emailCountLabel.text = [self emailCountLabelForSitter:self.sitter];
    self.navigationItem.title = self.sitter.fullName;
}

- (NSString *)phoneCountLabelForSitter:(SCSitter *)aSitter {
    NSString *result = @"";
    if (aSitter.phoneNumbers.count > 1) {
        result = [NSString stringWithFormat:@"(%lu more)", aSitter.phoneNumbers.count - 1];
    }
    return result;
}

- (NSString *)emailCountLabelForSitter:(SCSitter *)aSitter {
    NSString *result = @"";
    if (aSitter.emailAddresses.count > 1) {
        result = [NSString stringWithFormat:@"(%lu more)", aSitter.emailAddresses.count - 1];
    }
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
