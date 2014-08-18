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
#import "SCCacheManager.h"
#import "SCClient.h"
#import "SCConstants.h"

NSString *const kEXPIRED = @"EXPIRED";

@interface SCSessionManager ()
@property (nonatomic, retain, readwrite) SCUser *user;
@property (nonatomic, retain) NSString *docPath;
@property (nonatomic, retain) SCClient *client;
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
        
        _client = [[SCClient alloc] init];
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

- (SCUser *)fetchUserFromCache {
    NSLog(@"fetching user from cache");
    SCUser *user = nil;
    SCUserCache *cache = [SCCacheManager loadUserCache];
    if (cache) {
        NSLog(@"There is a user cache!");
        user = cache.userData;
        NSLog(@"user from cache: %@", user);
    } else {
        NSLog(@"No user cache");
    }
    
    
    return user;
}

- (void)fetchUserFromNetworkByFBID:(NSString *)fbId fbToken:(NSString *)token {
    NSLog(@"fetching user from network");
    //TODO: Implement logic to pull user from network and assign to user object...
    
    //TODO: update user in cache --> [self saveUserToCache:user];
    
}

- (BOOL)saveUser:(SCUser *)user {
    BOOL result = NO;
    
    [self saveUserToCache:user];
    [self saveUserToServer:user];
    
    return result;
}

- (BOOL)saveUserToCache:(SCUser *) user {
    //use NSCoding and FileManager
    BOOL result = NO;
    
    SCUserCache *cache = [SCCacheManager loadUserCache];
    if (!cache) {
        cache = [[SCUserCache alloc] initWithUser:user];
        result = [cache saveData];
    } else {
        cache.userData = user;
        result = [cache saveData];
    }
    
    return result;
}

- (void)createUserOnServer:(SCUser *)user {
    NSString *routesPlist = [[NSBundle mainBundle] pathForResource:@"routes" ofType:@"plist"];
    NSDictionary *routes = [[NSDictionary alloc] initWithContentsOfFile:routesPlist];
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:user.userAsDictionary options:kNilOptions error:&error];
    if (!error) {
        [self.client postJSONData:data toRelativeURLString:routes[kURL_KEY_CREATE_USER]];
    }
    
}

- (void)saveUserToServer:(SCUser *)user {
    NSString *routesPlist = [[NSBundle mainBundle] pathForResource:@"routes" ofType:@"plist"];
    NSDictionary *routes = [[NSDictionary alloc] initWithContentsOfFile:routesPlist];
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:user.userAsDictionary options:kNilOptions error:&error];
    if (!error) {
        [self.client postJSONData2:data toRelativeURLString:routes[kURL_KEY_SAVE_USER]];
    }
}

- (void)signInForUser:(SCUser *)user {
    NSString *routesPlist = [[NSBundle mainBundle] pathForResource:@"routes" ofType:@"plist"];
    NSDictionary *routes = [[NSDictionary alloc] initWithContentsOfFile:routesPlist];
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:user.userAsDictionary options:kNilOptions error:&error];
    if (!error) {
        [self.client postJSONData:data toRelativeURLString:routes[kURL_KEY_SIGN_IN]];
    }
}




#pragma mark - Facebook Connection requests...
- (RACSignal *)authenticateUsingFacebookWithPermissions:(NSArray *)permissions {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [FBSession openActiveSessionWithReadPermissions: permissions
                                           allowLoginUI: NO
                                      completionHandler: ^(FBSession *session, FBSessionState status, NSError *error) {
                                          
                                          if (!error) {
                                              if (status == FBSessionStateOpen) {
                                                  [subscriber sendCompleted];
                                              } else {
                                                  NSError *sessionError = [NSError errorWithDomain:@"fbSessionNotOpen" code:1 userInfo:nil];
                                                  [subscriber sendError:sessionError];
                                              }
                                          } else {
                                              [subscriber sendError:error];
                                          }
                                          
                                          
                                      }];
        return [RACDisposable disposableWithBlock:^{
            //terminate any processes here...
        }];
    }];
}

- (BOOL)facebookTokenAvailable {
    BOOL result = NO;
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        result = YES;
    }
    return result;
}


//- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) status error:(NSError *)error {
////    NSLog(@"%@", session.accessTokenData);
//    
//    if (status == FBSessionStateOpen) {
//        //TODO: Take action based on session state...
//        self.user = [self fetchUserFromCache];
//        
//        if (self.user == nil) {
//            NSLog(@"no fbID - go get it");
//            //TODO: can we pass in the function to fetchUserFromNetworkByFBID into this method?
//            //  because when this is done, we need to get the user from network.
//            //  Right now it the call to the network is buried inside it.
//            
//            [self fetchFacebookUserWithToken: session.accessTokenData.accessToken];
//            
//        } else if (self.user.expired) {
//            [self fetchUserFromNetworkByFBID:self.user.fbId fbToken:self.user.accessToken];
//        }
//    }
//}

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
            
            [self saveUser:self.user];
//            [self saveUserToCache:self.user];

            [self fetchUserFromNetworkByFBID:fbId fbToken:token];
        } else {
            NSLog(@"ERROR: unable to fetch user from fb.  Error: %@", [error localizedDescription]);
        }
    }];
}




@end
