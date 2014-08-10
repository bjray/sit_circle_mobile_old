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
}

- (id)initWithFacebookUser:(id<FBGraphUser>) fbUser withToken: (NSString *)token {
    NSString *firstName = @"Jane";
    NSString *lastName = @"Doe";
    NSString *fbId = nil;
    
    if (fbUser) {
        firstName = fbUser.first_name;
        lastName = fbUser.last_name;
        fbId = fbUser.id;
    }
    
    return [self initWithFirstName:firstName lastName:lastName fbId:fbId accessToken:token];
}

// Designated Initializer...
- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName fbId:(NSString *)fbId accessToken:(NSString *)accessToken {
    
    self = [super init];
    if (self) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.fbId = fbId;
        self.accessToken = accessToken;
        self.circles = [NSMutableArray array];
        self.expired = NO;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    NSString *firstName = [aDecoder decodeObjectForKey:@"firstName"];
    NSString *lastName = [aDecoder decodeObjectForKey:@"lastName"];
    NSString *fbId = [aDecoder decodeObjectForKey:@"fbId"];
    NSString *accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
//    NSString *accessToken = nil;
    
    return [self initWithFirstName:firstName lastName:lastName fbId:fbId accessToken:accessToken];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.fbId forKey:@"fbId"];
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
}

- (void)createDefaultCircle {
    SCCircle *aCircle = [[SCCircle alloc] init];
    aCircle.name = @"My Circle";
    aCircle.ownerId = self.fbId;
    aCircle.sitters = [NSMutableArray array];
    [self.circles addObject:aCircle];
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

- (NSDictionary *)userAsDictionary {
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSDictionary *dict = @{@"first_name":self.firstName, @"last_name": self.lastName, @"facebook_id":self.fbId, @"access_token":self.accessToken};
    
    return dict;
}

@end
