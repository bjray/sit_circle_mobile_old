//
//  SCContactsHelper.m
//  SitCircles
//
//  Created by B.J. Ray on 6/29/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//


#import "SCContactsHelper.h"


@implementation SCContactsHelper

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

- (void)requestContacts {
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        [self requestAddressBookAuth];
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        [self loadContacts];
    } else {
        NSLog(@"denied");
        //TODO: message back that access has been denied...
    }
    
    _contacts = [NSArray array];
}

// Not sure if this needs to be private...
- (BOOL)isContact:(SCContact *) contact equalTo:(ABRecordRef) person {
    BOOL result = NO;
    #warning Incomplete method implementation.
    return result;
}


#pragma mark - Customer Getter



#pragma mark - Private Methods

- (void)requestAddressBookAuth {
    
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
        if (!granted) {
            NSLog(@"just denied!");
            return;
        }
        NSLog(@"Authorized");
        [self loadContacts];
    });
}

- (void)loadContacts {
//    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFErrorRef *error;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    NSInteger peopleCount = ABAddressBookGetPersonCount(addressBook);
    SCContact *contact;
    
    for (NSInteger i=0; i < peopleCount; i++) {
        contact = [[SCContact alloc] init];
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //Should we check for record type?
        
        contact.uniqueId = ABRecordGetRecordID(person);
        contact.firstName = [self stringForABRecordRef:person forSingleValue:kABPersonFirstNameProperty];
        contact.lastName = [self stringForABRecordRef:person forSingleValue:kABPersonLastNameProperty];
        contact.numbers = [self dictionaryForABRecordRef:person forMultiValue:kABPersonPhoneProperty];
        NSLog(@"contact: %@", contact);
    }

}

- (NSMutableDictionary *)contactInfoDictionaryDefinition {
    NSMutableDictionary *contactInfoDict = [[NSMutableDictionary alloc]
                                            initWithObjects:@[@"", @"", @"", @"", @"", @"", @"", @"", @""]
                                            forKeys:@[@"firstName", @"lastName", @"mobileNumber", @"homeNumber", @"homeEmail", @"workEmail", @"address", @"zipCode", @"city"]];
    return contactInfoDict;
}


- (NSString *)stringForABRecordRef:(ABRecordRef)person forSingleValue:(ABPropertyID)propertyId {
    NSString *result = @"";
    CFTypeRef generalCFObject = ABRecordCopyValue(person, propertyId);
    if (generalCFObject) {
        result = (NSString *)CFBridgingRelease(generalCFObject);
        CFRelease(generalCFObject);
    }
    return result;
}

- (NSDictionary *)dictionaryForABRecordRef:(ABRecordRef)person forMultiValue:(ABPropertyID)propertyId {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    // Get the multi-value property.
    ABMultiValueRef multiRef = ABRecordCopyValue(person, propertyId);
    
    for (int i=0; i<ABMultiValueGetCount(multiRef); i++) {
        NSString *label = (NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(multiRef, i));
        NSString *value = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(multiRef, i));
        
//        label = [self searchAndReplaceText:@"/\_\$!\<([^>]+)\>\!\$\_/" withText:@"" forText:label];
        
        //**************************************************
        //TODO: Total hack but for some reason the _$!< and >!$_ are invisible to regEx...
        if ([label rangeOfString:@"Home"].location != NSNotFound) {
            label = @"Home";
        }
        
        if ([label rangeOfString:@"Mobile"].location != NSNotFound) {
            label = @"Mobile";
        }
        //**************************************************
                
        [dict setObject:value forKey:label];
        
    }
    CFRelease(multiRef);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}


- (NSString *)searchAndReplaceText: (NSString *)searchString
                          withText:(NSString *)replacementString
                           forText:(NSString *)original {
    
    NSString *result = [NSString stringWithString:original];
    
    NSRange range = NSMakeRange(0, original.length);
    NSError *error = NULL;
    NSRegularExpressionOptions regExOptions = NSRegularExpressionCaseInsensitive;
    
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern: searchString
                                                                           options:regExOptions
                                                                             error:&error];
    
    if (error) {
        NSLog(@"Couldn't create regex with given string and options");
    } else {
        result = [regEx stringByReplacingMatchesInString:original
                                                           options:0 range:range
                                                      withTemplate:replacementString];
    }
    
    return result;
}


@end
