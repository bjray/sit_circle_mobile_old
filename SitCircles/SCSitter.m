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

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (UIImage *)image {
    if (self.imageData) {
        return [UIImage imageWithData:self.imageData];
    }
    
    return [UIImage imageNamed:@"placeholder"];
}


- (SCPhoneNumber *)primaryPhone {

    
    SCPhoneNumber *pNumber = nil;

//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    NSError *error;
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SCPhoneNumber"
//                                              inManagedObjectContext:self.managedObjectContext];
//    
//    
//    [request setEntity:entity];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isPrimary == 1"];
//    [request setPredicate:predicate];
//    
//
//    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (SCPhoneNumber *number in self.phoneNumbers) {
        if (number.isPrimary) {
            pNumber = number;
            break;
        }
    }
    
    return pNumber;
}

- (SCEmailAddress *)primaryEmail {
    
    SCEmailAddress *pEmail = nil;
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    NSError *error;
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SCEmailAddress"
//                                              inManagedObjectContext:self.managedObjectContext];
//    
//    
//    [request setEntity:entity];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isPrimary == 1"];
//    [request setPredicate:predicate];
//    
//    
//    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (SCEmailAddress *email in self.emailAddresses) {
        if (email.isPrimary) {
            pEmail = email;
            break;
        }
    }
    
    return pEmail;
}

@end
