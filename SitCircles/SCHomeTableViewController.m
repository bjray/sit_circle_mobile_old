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
#import "SCCustomNoteViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


#define CIRCLE_ROW 0
#define WHEN_LABEL_ROW 1
#define DATE_ROW 2
#define HOW_LONG_LABEL_ROW 3
#define DURATION_ROW 4
#define NOTE_ROW 5
#define BOOK_IT_ROW 6
#define APPOINTMENTS_ROW 7
#define ANIMATION_DURATION 0.25f
static NSString *defaultNote = @"Hey #sitter#, I'm looking for a babysitter and was hoping you are available.  Reply to this message if you are available.  Thanks!";

@interface SCHomeTableViewController ()
@property (nonatomic, retain)NSArray *minutesArray;
@property (nonatomic) BOOL canBook;
@property (nonatomic, retain)NSDate *startDate;
@property (nonatomic, retain)NSDate *endDate;
@property (nonatomic, retain)NSString *note;
@end

@implementation SCHomeTableViewController
{
    SCCustomNoteViewController *_customNoteVC;
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
    self.canBook = NO;
    self.appointmentDatePicker.hidden = YES;
    self.appointmentDurationPicker.hidden = YES;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_background"]];
    
    self.minutesArray = @[@"0",@"15",@"30",@"45"];
    self.startDate = [NSDate date];
    
    [self displaySitterCount];
    [self.appointmentDatePicker setMinimumDate:self.startDate];
    

    RACSignal *startDateSignal = [[RACObserve(self, startDate) skip:1] doNext:^(id x) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:WHEN_LABEL_ROW inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }];
    
    RACSignal *endDateSignal = [RACObserve(self, endDate) doNext:^(id x) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:HOW_LONG_LABEL_ROW inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }];
    
    
    [RACObserve(self, note) subscribeNext:^(id x) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:NOTE_ROW inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }];
    
    RAC(self, canBook) = [[RACSignal combineLatest:@[startDateSignal, endDateSignal]
                                           reduce:^id(NSDate *startDt, NSDate *endDt){
                                               return @((startDt != nil) && (endDt != nil));
                                           }] doNext:^(id x) {
                                               NSIndexPath *indexPath = [NSIndexPath indexPathForItem:BOOK_IT_ROW inSection:0];
                                               UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                                               [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                                           }];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == CIRCLE_ROW) {
        return 200.0f;
    } else if (indexPath.row == DATE_ROW) {
        return self.appointmentDatePicker.hidden ? 0.0f : 217.0f;
    } else if (indexPath.row == DURATION_ROW) {
        return self.appointmentDurationPicker.hidden ? 0.0f : 217.0f;
    } else if (indexPath.row == APPOINTMENTS_ROW) {
        return 67.0f;
    } else {
        return 55.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath: %ld", indexPath.row);
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
    } else if (indexPath.row == BOOK_IT_ROW) {
        if (self.canBook) {
            NSLog(@"lets book this bitch!");
            [self scheduleAppointment];
        } else {
            NSLog(@"can't book yet...");
        }
    }else {
        [self hidePicker:self.appointmentDatePicker withLabel:self.appointmentDateLabel];
        [self hidePicker:self.appointmentDurationPicker withLabel:self.appointmentDurationLbl];
        if (indexPath.row == NOTE_ROW) {
            [self addCustomNote];
        }
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
    label.textColor = [UIColor whiteColor];
    label.text = title;
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"picker row selected");
    NSInteger hour = 0;
    NSInteger minute = 0;
    
    if (component == 0) {
        hour = row;
    } else if (component == 2) {
        minute = [[_minutesArray objectAtIndex:row] integerValue];
    }
    
    self.endDate = [self dateFromStartDate:self.startDate hours:hour minutes:minute];
    self.appointmentDurationLbl.text = [NSString stringWithFormat:@"%li hr %li min", hour, minute];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 35.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0;
}


#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    BOOL result = NO;
    if ([identifier isEqualToString:@"BookItSegue"]) {
        result = self.canBook;
    }
    return result;
}

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // Pass the selected object to the new view controller.
//}


#pragma mark - User Actions
- (IBAction)appointmentDateChanged:(id)sender {
    self.startDate = self.appointmentDatePicker.date;
    self.appointmentDateLabel.text = [self formatDate:self.appointmentDatePicker.date];
}

- (void)cancelNote {
    NSLog(@"Cancel");
}

- (void)saveNote:(NSString *)note {
    self.note = note;
    NSLog(@"new note...");
}

- (void)scheduleAppointment {
//    NSDate *beginDate;
//    NSDate *endDate;
//    NSString *note = @"";
    SCSessionManager *manager = [SCSessionManager sharedManager];
    [[[manager createAppointmentForUser:manager.user
                            startDate:self.startDate
                              endDate:self.endDate
                                 note:self.note]
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSDictionary *json) {
         NSLog(@"json");
    } error:^(NSError *error) {
        NSLog(@"error");
    }];
    
}

#pragma mark - Helper Methods

- (void)fetchData {
    SCSessionManager *manager = [SCSessionManager sharedManager];
    [[[manager fetchAppointmentsByUser:manager.user]
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(id x) {
         NSLog(@"json");
     } error:^(NSError *error) {
         NSLog(@"error");
     }];
}

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
    
    //This ensures date gets set the first time...
    [self appointmentDateChanged:picker];
    
}

- (void)hidePicker:(UIView *)picker withLabel:(UILabel *)label {
    
    label.textColor = [UIColor whiteColor];
    
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
//        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
//        [self.formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
	}
    
	return [formatter stringFromDate:theDate];
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
    
    circle.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 2*radius, 2*radius)].CGPath;
    circle.position = CGPointMake(CGRectGetMidX(self.tableCellView.frame)-radius, CGRectGetMidY(self.tableCellView.frame)-radius);
    
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

- (void)addCustomNote {
    _customNoteVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCCustomNoteViewController"];
    [self addChildViewController:_customNoteVC];
    _customNoteVC.view.frame = self.view.bounds;
    _customNoteVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_customNoteVC.view];
    [_customNoteVC didMoveToParentViewController:self];
    _customNoteVC.textView.text = defaultNote;
    __weak SCHomeTableViewController *weakSelf = self;

    _customNoteVC.saveCallback = ^(NSString *note) {
        [weakSelf saveNote:note];
        [weakSelf hideCustomNoteView];
    };
    
    _customNoteVC.cancelCallback = ^{
        [weakSelf cancelNote];
        [weakSelf hideCustomNoteView];
    };
    
    _customNoteVC.view.alpha = 0.0f;
    [UIView animateWithDuration:0.4 animations:^{
        _customNoteVC.view.alpha = 1.0f;
    }];
}



- (void)hideCustomNoteView {
    [UIView animateWithDuration:0.2 animations:^{
        _customNoteVC.view.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        [_customNoteVC willMoveToParentViewController:nil];
        [_customNoteVC.view removeFromSuperview];
        [_customNoteVC removeFromParentViewController];
        _customNoteVC = nil;
    }];
}

- (NSDate *)dateFromStartDate:(NSDate *)startDt hours:(NSInteger)hrs minutes:(NSInteger)mins {
    NSTimeInterval totalSeconds = (hrs * 3600) + (mins * 60);
    NSDate *newDate = [startDt dateByAddingTimeInterval:totalSeconds];
    NSLog(@"delta dateTime: %@", newDate);
    return newDate;
}


@end
