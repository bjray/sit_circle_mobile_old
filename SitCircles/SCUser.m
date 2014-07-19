//
//  SCUser.m
//  SitCircles
//
//  Created by B.J. Ray on 6/15/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCUser.h"
#import "SCCircles.h"
#import "SCCircle.h"

@implementation SCUser

- (id)init {
    self = [super init];
    if (self) {
        SCCircle *aCircle = [[SCCircle alloc] init];
        self.circles = [NSMutableArray arrayWithObject:aCircle];
    }
    
    return self;
}


- (void)facebookUser:(id)fbUser withToken: (NSString *)token {
    NSMutableDictionary<FBOpenGraphObject> *dict = fbUser;
    self.firstName = [dict objectForKey:@"first_name"];
    self.lastName = [dict objectForKey:@"last_name"];
    self.accessToken = token;
    self.fbId = [dict objectForKey:@"id"];
    
    NSLog(@"woohoo!");
    
}

#pragma mark - Custom Setters / Getters

- (id<SCCircles>)primaryCircle {
    return [self.circles objectAtIndex:0];
}

@end
