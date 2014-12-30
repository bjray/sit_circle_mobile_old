//
//  SCUser.m
//  SitCircles
//
//  Created by B.J. Ray on 12/12/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCUser.h"
#import "SCAppointment.h"
#import "SCCircle.h"


@implementation SCUser

@dynamic fbAccessToken;
@dynamic fbID;
@dynamic firstName;
@dynamic lastName;
@dynamic lastNetworkLoad;
@dynamic userId;
@dynamic circles;
@dynamic appointments;

#pragma mark - Properties
- (SCCircle *)primaryCircle {
    SCCircle *pCircle = nil;
    
    for (SCCircle *aCircle in self.circles) {
        if (aCircle.isPrimary) {
            pCircle = aCircle;
            break;
        }
    }
    
    return pCircle;
}

#pragma mark - Methods
- (NSDictionary *)userAsDictionary {
    NSDictionary *dict = @{@"first_name":self.firstName, @"last_name": self.lastName, @"facebook_id":self.fbID, @"access_token":self.fbAccessToken};
    
    return dict;
}



@end
