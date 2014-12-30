//
//  SCAlertViewController.m
//  SitCircles
//
//  Created by B.J. Ray on 12/22/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCAlertViewController.h"

@interface SCAlertViewController ()

@end

@implementation SCAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_background"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - User Actions
-(IBAction)button1Click:(id)sender {
    NSLog(@"You clicked button 1");
    self.button1Callback();
}

-(IBAction)button2Click:(id)sender {
    NSLog(@"You clicked button 2");
    self.button2Callback();
}

-(IBAction)button3Click:(id)sender {
    NSLog(@"You clicked button 3");
    self.button3Callback();
}

@end
