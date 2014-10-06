//
//  SCSessionManager.m
//  SitCircles
//
//  Created by B.J. Ray on 7/27/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCSessionManager.h"
#import "SCClient.h"
#import "SCConstants.h"
#import "SCDataManager.h"
#import "SCCircle.h"

NSString *const kEXPIRED = @"EXPIRED";
NSInteger const kHOURS_TIL_EXPIRE = 24;


@interface SCSessionManager ()
@property (nonatomic, retain, readwrite) SCUser *user;
@property (nonatomic, retain) NSString *docPath;
@property (nonatomic, retain) SCClient *client;
@property (nonatomic, retain) NSString *fbToken;
@property (nonatomic, retain) NSDateFormatter *formatter;
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
        self.formatter = [[NSDateFormatter alloc] init];
        [self.formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.AAA'Z'"];
        
        _client = [[SCClient alloc] init];
        
    }
    
    return self;
}





- (void)logout {
    
}

#pragma mark - User Helpers

//- (SCUser *)fetchUserFromCacheOrNetworkByFBID:(NSString *)fbId fbToken:(NSString *)token {
//
//    //try to fetch from cache...
//    // if no, 
//    
//    SCUser *user = [self fetchUserFromCache];
//    
//    
//    
//    return user;
//}

- (void)loadUserFromCacheOrNetwork {
    //check if local user has expired...
    self.user = [self fetchUserFromCache];
    
    if ([self isCachedUserExpired:self.user]) {
        self.user.lastNetworkLoad = [NSDate date];
        
        NSDictionary *userDict = [self fetchUserDictionaryFromNetwork:self.user];
        [self updateUser:self.user withUserDictionary:userDict];
        
        //save user locally now that we have refreshed from network...
        [self saveUserToCache:self.user];
    }
}

- (void)loadUserFromCacheOrNetworkByFBUser:(id<FBGraphUser>)fbUser fbToken:(NSString *)token {
    //check if user is in cache
    SCUser *user = [self fetchUserFromCache];
    if (user != nil) {
        if (![user.fbID isEqualToString:fbUser.objectID]) {
            NSLog(@"Ahhh shit - user in DB doesn't match?");
            //TODO: delete user and create a new one...
        }
        
        //found user...
        self.user = user;
        self.fbToken = user.fbAccessToken;
        
        if ([self isCachedUserExpired:user]) {
            //TODO: Fetch user from server...
            self.user.lastNetworkLoad = [NSDate date];
            NSDictionary *userDict = [self fetchUserDictionaryFromNetwork:self.user];
            [self updateUser:self.user withUserDictionary:userDict];
            [self saveUserToCache:self.user];
        }
    } else {
        // no user stored...
        self.fbToken = token;
        NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
        [userDict setObject:token forKey:@"access_token"];
        [userDict setObject:fbUser.first_name forKey:@"first_name"];
        [userDict setObject:fbUser.last_name forKey:@"last_name"];
        [userDict setObject:fbUser.objectID forKey:@"facebook_id"];
        
        [[self saveUserToServer:userDict] subscribeNext:^(id json) {
            self.user = [self createNewUserFromUserDictionary:json];
        } error:^(NSError *error) {
            NSLog(@"network error occurred...try to save user anyways...");
            self.user = [self createNewUserFromUserDictionary:userDict];
        }];
        
        NSLog(@"self.user: %@", self.user);
    }
}



- (SCUser *)fetchUserFromCache {
    //current assumes only 1 user in db at a time...
    NSLog(@"fetching user from cache");
    SCUser *user = nil;
    SCDataManager *dataManager = [SCDataManager sharedManager];
    
    NSManagedObjectContext *context = [dataManager managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SCUser"
                                              inManagedObjectContext:context];
    [request setEntity:entity];
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects != nil)  {
        if (objects.count > 0) {
            if (objects.count > 1) {
                NSLog(@"Not good - there was more than 1 user...");
            }
            if ([objects[0] isKindOfClass:[SCUser class]]) {
                user = (SCUser *)objects[0];
            } else {
                NSLog(@"Even worse...the objects returned aren't even Users!");
            }
        }
        
    }
    
    return user;
}

- (NSDictionary *)fetchUserDictionaryFromNetwork:(SCUser *)user {
    NSDictionary *dict = [NSDictionary dictionary];
    
    //TODO: Add implementation...
    return dict;
}

- (NSDictionary *)fetchUserDictionaryFromNetworkByFBID:(NSString *)fbId fbToken:(NSString *)token {
    NSDictionary *dict = [NSDictionary dictionary];
    
    //TODO: Add implementation...
    return dict;

}

//- (BOOL)saveUser:(SCUser *)user {
//    BOOL result = NO;
//    
//    [self saveUserToCache:user];
//    [self saveUserToServer:user];
//    
//    return result;
//}

- (BOOL)saveUserToCache:(SCUser *) user {
    BOOL result = NO;
    SCDataManager *dataManager = [SCDataManager sharedManager];
    
    
//    SCUserCache *cache = [SCCacheManager loadUserCache];
//    if (!cache) {
//        cache = [[SCUserCache alloc] initWithUser:user];
//        result = [cache saveData];
//    } else {
//        cache.userData = user;
//        result = [cache saveData];
//    }
    
    return result;
}

//- (void)createUserOnServer:(SCUser *)user {
//    NSString *routesPlist = [[NSBundle mainBundle] pathForResource:@"routes" ofType:@"plist"];
//    NSDictionary *routes = [[NSDictionary alloc] initWithContentsOfFile:routesPlist];
//    NSError *error = nil;
//    NSData *data = [NSJSONSerialization dataWithJSONObject:user.userAsDictionary options:kNilOptions error:&error];
//    if (!error) {
//        [self.client postJSONData:data toRelativeURLString:routes[kURL_KEY_CREATE_USER]];
//    }
//    
//}

- (RACSignal *)saveUserToServer:(NSDictionary *)userDict {
    NSString *routesPlist = [[NSBundle mainBundle] pathForResource:@"routes" ofType:@"plist"];
    NSDictionary *routes = [[NSDictionary alloc] initWithContentsOfFile:routesPlist];
    
    return [self.client postJSONData:userDict toRelativeURLString:routes[kURL_KEY_SAVE_USER]];
    
}

- (void)signInForUser:(SCUser *)user {
    NSString *routesPlist = [[NSBundle mainBundle] pathForResource:@"routes" ofType:@"plist"];
    NSDictionary *routes = [[NSDictionary alloc] initWithContentsOfFile:routesPlist];
    
    
    [self.client postJSONData:user.userAsDictionary toRelativeURLString:routes[kURL_KEY_SIGN_IN]];
}

- (BOOL)isCachedUserExpired: (SCUser *)user  {
    BOOL result = NO;
    
    if ((user == nil) || (user.lastNetworkLoad == nil)) {
        //no cached user or no lastNetworkLoad, so force expire...
        result = YES;
    } else {
        NSTimeInterval diffBetweenDates = [self.user.lastNetworkLoad timeIntervalSinceNow];
        double secondsInAnHour = 3600;
        NSInteger differenceInHours = diffBetweenDates / secondsInAnHour;
        
        if (differenceInHours > kHOURS_TIL_EXPIRE) {
            result = YES;
            NSLog(@"Expired!!!");
        }
    }
    
    return result;
}


- (void)updateUser:(SCUser *)user withUserDictionary:(NSDictionary *)dict {
    //TODO: Add implementation...
}

- (SCUser *)createNewUserFromUserDictionary:(NSDictionary *)dict {
    SCDataManager *dataManager = [SCDataManager sharedManager];
    
    //map dict (from server) into user object...
    
    NSManagedObjectContext *context = [dataManager managedObjectContext];
    SCUser *user = [NSEntityDescription insertNewObjectForEntityForName:@"SCUser"
                                                 inManagedObjectContext:context];
    
    user.firstName = [dict valueForKey:@"first_name"];
    user.lastName = [dict valueForKey:@"last_name"];
    user.fbID = [dict valueForKey:@"facebook_id"];
    user.userId = [dict valueForKey:@"id"];
    user.fbAccessToken = self.fbToken;
    
    NSDictionary *circleDict = [self circleDictFromUserJson:dict];
    
    SCCircle *circle = [NSEntityDescription insertNewObjectForEntityForName:@"SCCircle"
                                                     inManagedObjectContext:context];
    circle.name = [circleDict valueForKey:@"name"];

    circle.circleId = [NSNumber numberWithInteger:[[circleDict valueForKey:@"id"] integerValue]];
    circle.updatedAt = [_formatter dateFromString:[circleDict valueForKey:@"updated_at"]];;
    circle.createdAt = [_formatter dateFromString:[circleDict valueForKey:@"created_at"]];

    [user addCirclesObject:circle];
    [dataManager saveContext];
    NSLog(@"created New User locally!");
    return user;
}

#pragma mark - Helper functions
- (NSDictionary *)circleDictFromUserJson:(NSDictionary *)userDict {
    NSDictionary *circleDict = nil;
    NSArray *array = [userDict objectForKey:@"circles"];
    if (array.count > 0) {
        circleDict = array[0];
    } else {
        NSDate *date = [NSDate date];
        circleDict = @{@"name": @"My sitters", @"updated_at":[self.formatter stringFromDate:date], @"created_at":[self.formatter stringFromDate:date]};
    }
    return circleDict;
}


#pragma mark - Facebook Connection requests...
- (RACSignal *)authenticateUsingFacebookWithPermissions:(NSArray *)permissions {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [FBSession openActiveSessionWithReadPermissions: permissions
                                           allowLoginUI: NO
                                      completionHandler: ^(FBSession *session, FBSessionState status, NSError *error) {
                                          
                                          if (!error) {
                                              if (status == FBSessionStateOpen) {
//                                                  [self loadUserFromCacheOrNetwork];
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

//- (void)fetchFacebookUserWithToken:(NSString *)token {
//    NSLog(@"BEGIN: fetching user from FB");
//    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//        if (!error) {
//            NSLog(@"COMPLETE: fetched user from fb: %@", result);
//            id<FBGraphUser>fbUser = result;
//            NSString *fbId = fbUser.id;
//
////            self.user = [[SCUser alloc] initWithFacebookUser:fbUser withToken:token];
////            [self.user createDefaultCircle];
//            
////            [self saveUser:self.user];
////            [self saveUserToCache:self.user];
//
////            [self fetchUserFromNetworkByFBID:fbId fbToken:token];
//        } else {
//            NSLog(@"ERROR: unable to fetch user from fb.  Error: %@", [error localizedDescription]);
//        }
//    }];
//}

#pragma mark - Sitter Network Helpers...
- (RACSignal *)saveSitterAsDictionary:(NSDictionary *)dict {
    NSString *routesPlist = [[NSBundle mainBundle] pathForResource:@"routes" ofType:@"plist"];
    NSDictionary *routes = [[NSDictionary alloc] initWithContentsOfFile:routesPlist];
    
    return [[self.client postJSONData:dict toRelativeURLString:routes[kURL_KEY_BABYSITTERS]] deliverOn:RACScheduler.mainThreadScheduler];
}

- (RACSignal *)fetchSittersByUser:(SCUser *)user {
    NSString *routesPlist = [[NSBundle mainBundle] pathForResource:@"routes" ofType:@"plist"];
    NSDictionary *routes = [[NSDictionary alloc] initWithContentsOfFile:routesPlist];

    //TODO: Fine now because user will only have 1 circle...
    SCCircle *aCircle = [user.circles anyObject];
    NSInteger circleId = [aCircle.circleId integerValue];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%ld", routes[kURL_KEY_BABYSITTERS], circleId];
    return [[self.client fetchJSONFromRelativeURLString:urlString] deliverOn:RACScheduler.mainThreadScheduler];
}
@end
