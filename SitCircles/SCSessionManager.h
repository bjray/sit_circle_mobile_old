//
//  SCSessionManager.h
//  SitCircles
//
//  Created by B.J. Ray on 7/27/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCUser.h"

@interface SCSessionManager : NSObject

@property (nonatomic, retain, readonly) SCUser *user;

+(instancetype)sharedManager;
- (void)logout;
- (BOOL)facebookTokenAvailable;
- (void)authenticateUsingFacebookWithPermissions:(NSArray *)permissions;
//- (SCUser *)fetchUserFromCacheOrNetwork;
//- (SCUser *)fetchUserFromNetworkOnlyByFBID:(NSString *)fbId fbToken:(NSString *)token;
- (BOOL)saveUser:(SCUser *)user;
@end
