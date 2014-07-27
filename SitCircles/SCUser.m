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
    return [self initWithFacebookUser:nil withToken:nil];
//    self = [super init];
//    if (self) {
//        SCCircle *aCircle = [[SCCircle alloc] init];
//        self.circles = [NSMutableArray arrayWithObject:aCircle];
//    }
//    
//    return self;
}

- (id)initWithFacebookUser:(id<FBGraphUser>) fbUser withToken: (NSString *)token {
    self = [super init];
    if (self) {
        SCCircle *aCircle = [[SCCircle alloc] init];
        self.circles = [NSMutableArray arrayWithObject:aCircle];
        
        if (fbUser) {
            self.firstName = fbUser.first_name;
            self.lastName = fbUser.last_name;
            self.fbId = fbUser.id;
        }
        
        if (token) {
            self.accessToken = token;
        }
    }
    
    return self;
}


- (void)facebookUser:(id<FBOpenGraphObject>)fbUser withToken: (NSString *)token {
//    NSMutableDictionary<FBOpenGraphObject> *dict = fbUser;
    self.firstName = [fbUser objectForKey:@"first_name"];
    self.lastName = [fbUser objectForKey:@"last_name"];
    self.accessToken = token;
    self.fbId = [fbUser objectForKey:@"id"];
    
    NSLog(@"woohoo!");
    
}

#pragma mark - Custom Setters / Getters

- (id<SCCircles>)primaryCircle {
    return [self.circles objectAtIndex:0];
}

@end
