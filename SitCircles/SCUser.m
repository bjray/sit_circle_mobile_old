//
//  SCUser.m
//  SitCircles
//
//  Created by B.J. Ray on 8/25/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCUser.h"
#import "SCCircle.h"


@implementation SCUser

@dynamic lastNetworkLoad;
@dynamic fbAccessToken;
@dynamic fbID;
@dynamic firstName;
@dynamic lastName;
@dynamic userId;
@dynamic circles;


- (NSDictionary *)userAsDictionary {
    NSDictionary *dict = @{@"first_name":self.firstName, @"last_name": self.lastName, @"facebook_id":self.fbID, @"access_token":self.fbAccessToken};
    
    return dict;
}

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

#pragma mark - Custom Setters / Getters

- (id<SCCircles>)primaryCircle {
    return [self.circles objectAtIndex:0];
}

@end
