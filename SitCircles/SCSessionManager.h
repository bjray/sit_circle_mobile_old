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

@interface SCSessionManager : NSObject

@property (nonatomic, retain, readonly) SCUser *user;

+(instancetype)sharedManager;
- (void)logout;
- (BOOL)facebookTokenAvailable;
- (RACSignal *)authenticateUsingFacebookWithPermissions:(NSArray *)permissions;
//- (SCUser *)fetchUserFromCacheOrNetwork;
//- (SCUser *)fetchUserFromNetworkOnlyByFBID:(NSString *)fbId fbToken:(NSString *)token;
- (BOOL)saveUser:(SCUser *)user;
@end
