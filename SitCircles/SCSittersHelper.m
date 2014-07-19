//
//  SCSittersHelper.m
//  SitCircles
//
//  Created by B.J. Ray on 7/19/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCSittersHelper.h"


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

- (NSMutableArray *)sittersFromContacts:(NSArray *)contacts {
    NSMutableArray *sitters = [NSMutableArray array];
    
    for (SCContact *contact in contacts) {
        [sitters addObject:[self sitterFromContact:contact]];
    }
    
    return sitters;
}

- (SCSitter *)sitterFromContact:(SCContact *)contact {
    SCSitter *sitter = [[SCSitter alloc] init];
    sitter.firstName = contact.firstName;
    sitter.lastName = contact.lastName;
    sitter.addressBookId = contact.uniqueId;
    sitter.numbers = contact.numbers;
    sitter.emails = contact.emails;
    sitter.image = contact.image;
    sitter.primaryEmailLabel = contact.primaryEmailLabel;
    sitter.primaryEmailValue = contact.primaryEmailValue;
    sitter.primaryNumberLabel = contact.primaryNumberLabel;
    sitter.primaryNumberValue = contact.primaryNumberValue;
    
    
    
    return sitter;
}

@end
