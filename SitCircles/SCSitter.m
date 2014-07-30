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


#pragma mark - Archiving logic

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.sitterId = [aDecoder decodeObjectForKey:@"sitterId"];
    self.addressBookId = [aDecoder decodeIntegerForKey:@"addressBookId"];
    self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
    self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
    self.emails = [aDecoder decodeObjectForKey:@"emails"];
    self.numbers = [aDecoder decodeObjectForKey:@"numbers"];
    self.primaryEmailLabel = [aDecoder decodeObjectForKey:@"primaryEmailLabel"];
    self.primaryEmailValue = [aDecoder decodeObjectForKey:@"primaryEmailValue"];
    self.primaryNumberLabel = [aDecoder decodeObjectForKey:@"primaryNumberLabel"];
    self.primaryNumberValue = [aDecoder decodeObjectForKey:@"primaryNumberValue"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    // TODO: Handle Image directly with SitterCache class...
    [aCoder encodeObject:self.sitterId forKey:@"sitterId"];
    [aCoder encodeInteger:self.addressBookId forKey:@"addressBookId"];
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.emails forKey:@"emails"];
    [aCoder encodeObject:self.numbers forKey:@"numbers"];
    [aCoder encodeObject:self.primaryEmailLabel forKey:@"primaryEmailLabel"];
    [aCoder encodeObject:self.primaryEmailValue forKey:@"primaryEmailValue"];
    [aCoder encodeObject:self.primaryNumberLabel forKey:@"primaryNumberLabel"];
    [aCoder encodeObject:self.primaryNumberValue forKey:@"primaryNumberValue"];
}
@end
