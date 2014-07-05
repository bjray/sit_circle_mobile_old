//
//  SCUser.h
//  SitCircles
//
//  Created by B.J. Ray on 6/15/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SCUser : NSObject
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *fbId;
@property (nonatomic, copy) NSString *accessToken;
@property BOOL reviewTCs;
@property BOOL newUser;
@property (nonatomic, retain) NSMutableArray *circles;


- (void)facebookUser:(id)fbUser withToken: (NSString *)token;

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
