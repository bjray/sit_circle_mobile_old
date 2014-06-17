//
//  SCLoginHelper.m
//  SitCircles
//
//  Created by B.J. Ray on 6/7/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCLoginHelper.h"

@implementation SCLoginHelper


#pragma mark - FBLoginViewDelegate
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"user: %@", user);
}

@end
