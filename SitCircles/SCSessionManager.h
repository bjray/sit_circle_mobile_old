//
//  SCSessionManager.h
//  SitCircles
//
//  Created by B.J. Ray on 7/27/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCUser.h"
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import <FacebookSDK/FacebookSDK.h>
@class SCSitter;

@interface SCSessionManager : NSObject

@property (nonatomic, retain, readonly) SCUser *user;

+(instancetype)sharedManager;
- (void)logout;
- (BOOL)facebookTokenAvailable;
- (RACSignal *)authenticateUsingFacebookWithPermissions:(NSArray *)permissions;
- (void)loadUserFromCacheOrNetwork;
- (void)loadUserFromCacheOrNetworkByFBUser:(id<FBGraphUser>)fbUser fbToken:(NSString *)token;

//- (BOOL)saveUser:(SCUser *)user;
- (RACSignal *)saveSitterAsDictionary:(NSDictionary *)dict;
- (RACSignal *)fetchSittersByUser:(SCUser *)user;
- (RACSignal *)createAppointmentForUser:(SCUser *)user
                              startDate:(NSDate *)start
                                endDate:(NSDate *)end
                                   note:(NSString *)note;

- (RACSignal *)fetchAppointmentsByUser:(SCUser *)user;
@end
