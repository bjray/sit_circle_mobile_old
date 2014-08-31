//
//  SCCircleViewController.h
//  SitCircles
//
//  Created by B.J. Ray on 6/22/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCAddressBookDelegate.h"
@class SCCircle;

@interface SCCircleViewController : UITableViewController <SCAddressBookDelegate>
@property (nonatomic,retain) SCCircle *circle;
@end
