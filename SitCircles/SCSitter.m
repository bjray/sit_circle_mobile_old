//
//  SCSitter.m
//  SitCircles
//
//  Created by B.J. Ray on 8/25/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCSitter.h"
#import "SCCircle.h"
#import "SCEmailAddress.h"
#import "SCPhoneNumber.h"
#import "SCDataManager.h"

@interface SCSitter ()
@property (nonatomic, retain, readwrite) SCPhoneNumber *primaryPhone;
@property (nonatomic, retain, readwrite) SCEmailAddress *primaryEmail;
@end

@implementation SCSitter
@dynamic imageData;
@dynamic firstName;
@dynamic lastName;
@dynamic addressBookId;
@dynamic sitterId;
@dynamic circle;
@dynamic emailAddresses;
@dynamic phoneNumbers;
@synthesize primaryPhone = _primaryPhone;
@synthesize primaryEmail = _primaryEmail;

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (UIImage *)image {
    return [UIImage imageWithData:self.imageData];
}


- (SCPhoneNumber *)primaryPhone {
    if (_primaryPhone) {
        return _primaryPhone;
    }
    
    SCPhoneNumber *pNumber = nil;

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SCPhoneNumber"
                                              inManagedObjectContext:self.managedObjectContext];
    
    
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isPrimary == 1"];
    [request setPredicate:predicate];
    

    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (SCPhoneNumber *number in objects) {
        if (number.isPrimary) {
            pNumber = number;
            break;
        }
    }
    self.primaryPhone = pNumber;
    
    return pNumber;
}

- (SCEmailAddress *)primaryEmail {
    if (_primaryEmail) {
        return _primaryEmail;
    }
    
    SCEmailAddress *pEmail = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SCEmailAddress"
                                              inManagedObjectContext:self.managedObjectContext];
    
    
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isPrimary == 1"];
    [request setPredicate:predicate];
    
    
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (SCEmailAddress *email in objects) {
        if (email.isPrimary) {
            pEmail = email;
            break;
        }
    }
    self.primaryEmail = pEmail;
    
    return pEmail;
}

@end
