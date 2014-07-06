//
//  SCContactsHelper.h
//  SitCircles
//
//  Created by B.J. Ray on 6/29/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import "SCContact.h"
@import AddressBook;

@interface SCContactsHelper : NSObject
@property (nonatomic, retain, readonly) NSArray *contacts;

+(instancetype)sharedManager;

- (RACSignal *)requestContacts;
- (BOOL)isContact:(SCContact *) contact equalTo:(ABRecordRef) person;
@end
