//
//  SCContact.m
//  SitCircles
//
//  Created by B.J. Ray on 7/4/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCContact.h"

@interface SCContact()
@property (nonatomic, retain, readwrite) NSString *primaryNumberLabel;
@property (nonatomic, retain, readwrite) NSString *primaryNumberValue;

@property (nonatomic, retain, readwrite) NSString *primaryEmailLabel;
@property (nonatomic, retain, readwrite) NSString *primaryEmailValue;

@end

@implementation SCContact

- (id)init {
    if (self = [super init]) {
        self.isLocked = NO;
    }
    
    return self;
}

#pragma mark - Custom Setters / Getters
- (void)setNumbers:(NSDictionary *)dict {
    _numbers = dict;
    
    NSString *key = [self keyOfPrimaryPhoneNumberInDictionary:dict];
    if (key) {
        self.primaryNumberLabel = key;
        self.primaryNumberValue = (NSString *)[dict objectForKey:key];
    }
}

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
}

- (void)setEmails:(NSDictionary *)emails {
    _emails = emails;
    NSString *key = [self keyOfPrimaryEmailInDictionary:emails];
    if (key) {
        self.primaryEmailLabel = key;
        self.primaryEmailValue = (NSString *)[emails objectForKey:key];
    }
}

#pragma mark - Private Methods

- (NSString *)keyOfPrimaryPhoneNumberInDictionary:(NSDictionary *)dict {
    NSString *theKey = nil;
    
    if ([dict count] == 1) {
        theKey = [[dict allKeys] objectAtIndex:0];
    } else {
        
        for (NSString *aKey in dict) {
            if ([aKey isEqualToString:@"iPhone"]) {
                theKey = @"iPhone";
                break;
            }
            
            if ([aKey isEqualToString:@"Mobile"]) {
                theKey = @"Mobile";
                break;
            }
        }
    }
    
    return theKey;
}

- (NSString *)keyOfPrimaryEmailInDictionary:(NSDictionary *)dict {
    NSString *theKey = nil;
    
    if ([dict count] >= 1) {
        theKey = [[dict allKeys] objectAtIndex:0];
    }
    
    return theKey;
}


- (NSString *)description {
//    return [NSString stringWithFormat:@"%@ %@, %@: %@", self.firstName, self.lastName, self.primaryNumberLabel, self.primaryNumberValue];
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}
@end
