//
//  SCHomeTableViewController.h
//  SitCircles
//
//  Created by B.J. Ray on 6/15/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCHomeTableViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *appointmentDurationLbl;
@property (weak, nonatomic) IBOutlet UILabel *appointmentDateLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *appointmentDurationPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *appointmentDatePicker;


- (IBAction)appointmentDateChanged:(id)sender;

@end
