//
//  SCSitter.m
//  SitCircles
//
//  Created by B.J. Ray on 7/19/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCSitter.h"

@interface SCSitter()


@end

@implementation SCSitter
@synthesize sitterId = _sitterId;
@synthesize addressBookId = _addressBookId;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize  numbers = _numbers;
@synthesize emails = _emails;
@synthesize image = _image;
@synthesize primaryEmailLabel = _primaryEmailLabel;
@synthesize primaryEmailValue = _primaryEmailValue;
@synthesize primaryNumberLabel = _primaryNumberLabel;
@synthesize primaryNumberValue = _primaryNumberValue;



- (id)init {
    if (self = [super init]) {
        self.sitterId = nil;
    }
    
    return self;
}

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
}
@end
