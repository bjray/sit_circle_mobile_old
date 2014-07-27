//
//  SCSessionManager.m
//  SitCircles
//
//  Created by B.J. Ray on 7/27/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCSessionManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SCUserCache.h"

NSString *const kEXPIRED = @"EXPIRED";

@interface SCSessionManager ()
@property (nonatomic, retain, readwrite) SCUser *user;
@property (nonatomic, retain) NSString *docPath;
@end

@implementation SCSessionManager

+(instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}


- (id)init {
    if (self = [super init]) {
        self.user = nil;
    }
    
    return self;
}





- (void)logout {
    
}

#pragma mark - User Helpers

//- (SCUser *)fetchUserFromCacheOrNetworkByFBID:(NSString *)fbId fbToken:(NSString *)token {
//    SCUser *user = [self fetchUserFromCache];
//    
//    
//    
//    return user;
//}

- (void)fetchUserFromCache {
    NSLog(@"fetching user from cache");
    //TODO: pull back user info from cache...
    
    //TODO: hydrate user...
}

- (void)fetchUserFromNetworkByFBID:(NSString *)fbId fbToken:(NSString *)token {
    NSLog(@"fetching user from network");
    //TODO: Implement logic to pull user from network and assign to user object...
    
    //TODO: update user in cache --> [self saveUserToCache:user];
    
}




#pragma mark - Facebook Connection requests...
- (void)authenticateUsingFacebookWithPermissions:(NSArray *)permissions {
    
    [FBSession openActiveSessionWithReadPermissions: permissions
                                       allowLoginUI: NO
                                  completionHandler: ^(FBSession *session, FBSessionState status, NSError *error) {
                                      [self sessionStateChanged:session state:status error:error];
                                  }];

}

- (BOOL)facebookTokenAvailable {
    BOOL result = NO;
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        result = YES;
    }
    return result;
}


- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) status error:(NSError *)error {
    NSLog(@"%@", session.accessTokenData);
    
    if (status == FBSessionStateOpen) {
        //TODO: Take action based on session state...
        NSString *fbId = [self fetchFacebookIdFromCache];
        
        if (fbId == nil) {
            NSLog(@"no fbID - go get it");
            [self fetchFacebookUserWithToken: (NSString *)session.accessTokenData];
        } else if (fbId == kEXPIRED) {
            NSLog(@"fbID expired - go fetch user from network");
            [self fetchUserFromNetworkByFBID:fbId fbToken:(NSString *)session.accessTokenData];
        } else {
            [self fetchUserFromCache];
        }
    }
    
    
}

- (void)fetchFacebookUserWithToken:(NSString *)token {
    NSLog(@"BEGIN: fetching user from FB");
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSLog(@"COMPLETE: fetched user from fb: %@", result);
            id<FBGraphUser>fbUser = result;
            NSString *fbId = fbUser.id;
            
#warning -- This line is only for testing before implementing network call --
            self.user = [[SCUser alloc] initWithFacebookUser:fbUser withToken:token];
            [self.user createDefaultCircle];
            

            [self fetchUserFromNetworkByFBID:fbId fbToken:token];
        } else {
            NSLog(@"ERROR: unable to fetch user from fb.  Error: %@", [error localizedDescription]);
        }
    }];
}


#pragma mark - File Manager methods

- (BOOL)saveUser:(SCUser *)user {
    BOOL result = NO;
    
    [self saveUserToCache:user];
    
    
    return result;
}

- (void)saveUserToCache:(SCUser *) user {
    //use NSCoding and FileManager
}

- (void)saveUserToServer:(SCUser *)user {
    
}

- (NSString *)fetchFacebookIdFromCache {
    NSString *fbId = nil;
    
    
    return fbId;
}


@end
