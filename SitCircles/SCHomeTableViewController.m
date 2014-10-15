//
//  SCHomeTableViewController.m
//  SitCircles
//
//  Created by B.J. Ray on 6/15/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCHomeTableViewController.h"
#import "SCSessionManager.h"
#import "SCUser.h"
#import "SCCircle.h"


#define CIRCLE_ROW 0
#define DATE_ROW 2
#define DURATION_ROW 4
#define ANIMATION_DURATION 0.25f

@interface SCHomeTableViewController ()
@property (nonatomic, retain)NSArray *minutesArray;
@end

@implementation SCHomeTableViewController
{
    NSInteger _hour;
    NSInteger _minute;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        NSLog(@"Init method fired...");
        
    }
    
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appointmentDatePicker.hidden = YES;
    self.appointmentDurationPicker.hidden = YES;
    
    _hour = 0;
    _minute = 0;

    self.minutesArray = @[@"0",@"15",@"30",@"45"];
    
    [self displaySitterCount];
    [self.appointmentDatePicker setMinimumDate:[NSDate date]];
}


- (void)displaySitterCount {
    SCSessionManager *manager = [SCSessionManager sharedManager];
    SCCircle *primaryCircle = [manager.user.circles anyObject];
    self.sitterCountLabel.text = [NSString stringWithFormat:@"%ld", [primaryCircle.sitters count]];
    
    UIColor *blue = [UIColor colorWithRed:(89.0/255.0) green:(181.0/255.0) blue:(218.0/255.0) alpha:1.0];
//    UIColor *orange = [UIColor colorWithRed:(230.0/255.0) green:(120.0/255.0) blue:(23.0/255.0) alpha:1.0];
    int radius = 80;
    CAShapeLayer *circle = [self drawCircleWithColor:blue radius:radius];
    [self animateCircle:circle];
    [self fadeInSitterCount];
    
}

- (void)fadeInSitterCount {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.sitterCountLabel.alpha = 1.0;
                         self.sitterLabel.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         nil;
                     }];
}

- (CAShapeLayer *)drawCircleWithColor: (UIColor *) color radius:(int) radius {
    CAShapeLayer *circle = [CAShapeLayer layer];
    
//    NSLog(@"tablecell Frame: %@", NSStringFromCGRect(self.tableCellView.frame));
    
    circle.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 2*radius, 2*radius)].CGPath;
    circle.position = CGPointMake(CGRectGetMidX(self.tableCellView.frame)-radius, CGRectGetMidY(self.tableCellView.frame)-radius);
    
//    NSLog(@"circle Position: %@", NSStringFromCGPoint(circle.position));
    
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = color.CGColor;
    circle.lineWidth = 5.0;
    
    return circle;
}

- (void)animateCircle: (CAShapeLayer *) circle {
    
    [self.tableCellView.layer addSublayer:circle];
    
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.delegate = self;
    drawAnimation.duration = 0.5; //animate over 3 seconds
    drawAnimation.repeatCount = 1.0;
    
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}



#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == CIRCLE_ROW) {
        return 200.0f;
    } else if (indexPath.row == DATE_ROW) {
        return self.appointmentDatePicker.hidden ? 0.0f : 217.0f;
    } else if (indexPath.row == DURATION_ROW) {
        return self.appointmentDurationPicker.hidden ? 0.0f : 217.0f;
    } else {
        return 44.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == DATE_ROW-1) {
        if (self.appointmentDatePicker.hidden) {
            [self showPicker:self.appointmentDatePicker withLabel:self.appointmentDateLabel];
            [self hidePicker:self.appointmentDurationPicker withLabel:self.appointmentDurationLbl];
        } else {
            [self hidePicker:self.appointmentDatePicker withLabel:self.appointmentDateLabel];
        }
    } else if (indexPath.row == DURATION_ROW-1) {
        if (self.appointmentDurationPicker.hidden) {
            [self showPicker:self.appointmentDurationPicker withLabel:self.appointmentDurationLbl];
            [self hidePicker:self.appointmentDatePicker withLabel:self.appointmentDateLabel];
        } else {
            [self hidePicker:self.appointmentDurationPicker withLabel:self.appointmentDurationLbl];
        }
    } else {
        [self hidePicker:self.appointmentDatePicker withLabel:self.appointmentDateLabel];
        [self hidePicker:self.appointmentDurationPicker withLabel:self.appointmentDurationLbl];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Picker DataSource Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 1 || component == 3 ) {
        return 1;
    } else if (component == 2) {
        return [self.minutesArray count];
    } else {
        return 24;
    }
}

#pragma mark - Picker Delegate Methods
-(UIView *)pickerView:(UIPickerView *)pickerView
           viewForRow:(NSInteger)row
         forComponent:(NSInteger)component
          reusingView:(UIView *)view {
    
    NSString *title = @"";
    
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"Avenir-Roman" size:14.0];
    }
    
    switch (component) {
        case 0:
            title = [[NSNumber numberWithInteger:row] stringValue];
            label.textAlignment = NSTextAlignmentRight;
            break;
        case 1:
            title = @"hr";
            label.textAlignment = NSTextAlignmentLeft;
            break;
        case 2:
            title = [self.minutesArray objectAtIndex:row];
            label.textAlignment = NSTextAlignmentRight;
            break;
        case 3:
            title = @"min";
            label.textAlignment = NSTextAlignmentLeft;
            break;
        default:
            break;
    }
    
    label.text = title;
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    NSLog(@"picker row selected");
    
    if (component == 0) {
        _hour = row;
    } else if (component == 2) {
        _minute = [[_minutesArray objectAtIndex:row] integerValue];
    }
    
    self.appointmentDurationLbl.text = [NSString stringWithFormat:@"%li hr %li min", _hour, _minute];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 35.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0;
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

#pragma mark - User Actions
- (IBAction)appointmentDateChanged:(id)sender {
    self.appointmentDateLabel.text = [self formatDate:self.appointmentDatePicker.date];
}

#pragma mark - Helper Methods
- (void)showPicker:(UIView *)picker withLabel:(UILabel *)label {
    //    NSIndexPath *pickerCellPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    label.textColor = self.tableView.tintColor;
    picker.hidden = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    picker.alpha = 0.0f;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        picker.alpha = 1.0f;
    }];
    
}

- (void)hidePicker:(UIView *)picker withLabel:(UILabel *)label {
    
    label.textColor = [UIColor blackColor];
    
    if (!picker.hidden) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            picker.alpha = 1.0f;
        } completion:^(BOOL finished) {
            picker.hidden = YES;
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }];
    }
}

- (NSString *)formatDate:(NSDate *)theDate
{
	static NSDateFormatter *formatter;
	if (formatter == nil) {
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:NSDateFormatterShortStyle];
	}
    
	return [formatter stringFromDate:theDate];
}
@end
