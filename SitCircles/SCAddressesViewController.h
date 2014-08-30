//
//  SCAddressesViewController.h
//  SitCircles
//
//  Created by B.J. Ray on 6/22/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCCircle;

@interface SCAddressesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) SCCircle *circle;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
@end
