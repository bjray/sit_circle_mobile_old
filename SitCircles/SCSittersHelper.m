//
//  SCSittersHelper.m
//  SitCircles
//
//  Created by B.J. Ray on 7/19/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCSittersHelper.h"
#import "SCDataManager.h"
#import "SCPhoneNumber.h"
#import "SCEmailAddress.h"
#import "SCCircle.h"

@implementation SCSittersHelper
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
    }
    
    return self;
}

- (NSSet *)sittersFromContacts:(NSArray *)contacts {
    NSMutableSet *sitters = [NSMutableSet set];
    
    for (SCContact *contact in contacts) {
        [sitters addObject:[self sitterFromContact:contact]];
    }
    
    return sitters;
}

- (SCSitter *)sitterFromContact:(SCContact *)contact {
    SCDataManager *dataManager = [SCDataManager sharedManager];
    NSManagedObjectContext *context = [dataManager managedObjectContext];
    SCSitter *sitter = [NSEntityDescription insertNewObjectForEntityForName:@"SCSitter"
                                                     inManagedObjectContext:context];
    
    sitter.firstName = contact.firstName;
    sitter.lastName = contact.lastName;
    sitter.addressBookId = [NSNumber numberWithLong:contact.uniqueId];
    [sitter addPhoneNumbers:[self phoneNumbersSetFromContact:contact forContext:context]];
    [sitter addEmailAddresses:[self emailAddressSetFromContact:contact forContext:context]];
        sitter.imageData = contact.imageData;

    return sitter;
}


- (NSSet *)phoneNumbersSetFromContact:(SCContact *)contact forContext:(NSManagedObjectContext *)context {
    NSMutableSet *set = [NSMutableSet set];
    SCPhoneNumber *phoneNumber;
    
    
    NSEnumerator *enumerator = [contact.numbers keyEnumerator];
    NSString *theKey = nil;
    
    while ((theKey = [enumerator nextObject])) {
        phoneNumber = [NSEntityDescription insertNewObjectForEntityForName:@"SCPhoneNumber"
                                                    inManagedObjectContext:context];
        
        phoneNumber.label = theKey;
        phoneNumber.value = [contact.numbers valueForKey:theKey];
        NSLog(@"phone for %@ is: %@", contact.firstName, phoneNumber.value);
        
        if ([theKey isEqualToString:@"iPhone"]) {
            phoneNumber.isPrimary = YES;
        } else if ([theKey isEqualToString:@"Mobile"]) {
            phoneNumber.isPrimary = YES;
        }
        [set addObject:phoneNumber];
    }
    
    //if there is only one, always make it primary...
    if (([set count] == 1) && (phoneNumber != nil)) {
        phoneNumber.isPrimary = YES;
    }
    
    return set;
}

- (NSSet *)emailAddressSetFromContact:(SCContact *)contact forContext:(NSManagedObjectContext *)context {
    NSMutableSet *set = [NSMutableSet set];
    SCEmailAddress *emailAddress;
    
    NSEnumerator *enumerator = [contact.emails keyEnumerator];
    NSString *theKey = nil;
    int i = 0;
    
    
    while ((theKey = [enumerator nextObject])) {
        emailAddress = [NSEntityDescription insertNewObjectForEntityForName:@"SCEmailAddress"
                                                    inManagedObjectContext:context];
        
        emailAddress.label = theKey;
        emailAddress.value = [contact.emails valueForKey:theKey];
        if (i == 0) {
            emailAddress.isPrimary = YES;
        }
        
        [set addObject:emailAddress];
        i++;
    }
    
    
    return set;
}


- (BOOL)sitters:(NSSet *)sitters containsContact:(id)contact {
    BOOL result = NO;
    if ([contact isKindOfClass:[SCContact class]]) {
        
        for (SCSitter *sitter in sitters) {
            result = [self compareSitter:sitter toContact:contact];
            if (result) {
                break;
            }
        }
    }
    
    if (result) {
        NSLog(@"contact exists in sitters list!!!");
    } else {
        NSLog(@"contact not found in sitters list");
    }
    
    return result;
}

- (BOOL)compareSitter:(SCSitter *)sitter toContact:(SCContact *)contact {
    BOOL result = NO;
    
    
    if ([sitter.addressBookId integerValue] == contact.uniqueId) {
        result = YES;
    }
    
    return result;
}

- (NSDictionary *)dictionaryFromSitter:(SCSitter *)sitter {
    NSDictionary *dict = @{@"first_name":(sitter.firstName) ? sitter.firstName : @"",
                           @"last_name": (sitter.lastName) ? sitter.lastName : @"",
                           @"phone_number":(sitter.primaryPhone) ? sitter.primaryPhone.value : @"",
                           @"email":(sitter.primaryEmail) ? sitter.primaryEmail.value : @"",
                           @"circle_id": (sitter.circle.circleId) ? sitter.circle.circleId : @""};

    return dict;
}


//- (BOOL)containsContact:(id)contact {
//    BOOL result = NO;
//    
//    
//    
//    SCSittersHelper *sitterHelper = [SCSittersHelper sharedManager];
//    result = [sitterHelper sitters:self.sitters containsContact:contact];
//    
//    return result;
//}

@end
