//
//  SCAlertViewController.h
//  SitCircles
//
//  Created by B.J. Ray on 12/22/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCAlertViewController : UIViewController
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextView *detailsTextField;
@property (nonatomic, weak) IBOutlet UIButton *button1;
@property (nonatomic, weak) IBOutlet UIButton *button2;
@property (nonatomic, weak) IBOutlet UIButton *button3;

-(IBAction)button1Click:(id)sender;
-(IBAction)button2Click:(id)sender;
-(IBAction)button3Click:(id)sender;

@property (nonatomic, copy) dispatch_block_t button1Callback;
@property (nonatomic, copy) dispatch_block_t button2Callback;
@property (nonatomic, copy) dispatch_block_t button3Callback;
@end
