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

@end

@implementation SCContact


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


- (NSString *)description {
//    return [NSString stringWithFormat:@"%@ %@, %@: %@", self.firstName, self.lastName, self.primaryNumberLabel, self.primaryNumberValue];
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}
@end
