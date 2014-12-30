//
//  SCCustomNoteViewController.m
//  SitCircles
//
//  Created by B.J. Ray on 10/16/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCCustomNoteViewController.h"

@interface SCCustomNoteViewController ()
@property (nonatomic, weak) IBOutlet UIView *contentView;
@end

@implementation SCCustomNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_background"]];
    // Do any additional setup after loading the view.
    self.textView.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)save:(id)sender {
    NSString *note = self.textView.text;
    self.saveCallback(note);
}

- (IBAction)cancel:(id)sender {
    self.cancelCallback();
}

@end
