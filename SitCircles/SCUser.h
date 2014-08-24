//
//  SCUser.h
//  SitCircles
//
//  Created by B.J. Ray on 6/15/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SCCircles.h"

@interface SCUser : NSObject <NSCoding>
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *fbId;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, retain) NSMutableArray *circles;
@property (nonatomic, retain) NSDate *lastNetworkLoad;
@property (nonatomic, retain, readonly) id<SCCircles> primaryCircle;
@property BOOL authenticated;
@property BOOL expired;


- (void)facebookUser:(id<FBOpenGraphObject>)fbUser withToken: (NSString *)token __attribute__((deprecated));
- (id)initWithFacebookUser:(id<FBGraphUser>) fbUser withToken: (NSString *)token;

- (void)createDefaultCircle;
- (NSDictionary *)userAsDictionary;

/*
 Note: We can also get the following properties from the FB user:
 - email
 - gender
 - link
 - locale ("en-us")
 - name ("B.J. Ray")
 - timezone ("-5")
 - updated_time
 - verified
 */
@end
