//
//  SCSitter.h
//  SitCircles
//
//  Created by B.J. Ray on 8/25/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCCircle, SCEmailAddress, SCPhoneNumber;

@interface SCSitter : NSManagedObject

@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * addressBookId;
@property (nonatomic, retain) NSNumber * sitterId;
@property (nonatomic, retain) SCCircle *circle;
@property (nonatomic, retain) NSSet *emailAddresses;
@property (nonatomic, retain) NSSet *phoneNumbers;

@property (nonatomic, retain, readonly) NSString *fullName;
@property (nonatomic, retain, readonly) UIImage *image;
@property (nonatomic, retain, readonly) SCPhoneNumber *primaryPhone;
@property (nonatomic, retain, readonly) SCEmailAddress *primaryEmail;
@end

@interface SCSitter (CoreDataGeneratedAccessors)

- (void)addEmailAddressesObject:(SCEmailAddress *)value;
- (void)removeEmailAddressesObject:(SCEmailAddress *)value;
- (void)addEmailAddresses:(NSSet *)values;
- (void)removeEmailAddresses:(NSSet *)values;

- (void)addPhoneNumbersObject:(SCPhoneNumber *)value;
- (void)removePhoneNumbersObject:(SCPhoneNumber *)value;
- (void)addPhoneNumbers:(NSSet *)values;
- (void)removePhoneNumbers:(NSSet *)values;

@end
