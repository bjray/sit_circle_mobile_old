//
//  SCCircle.m
//  SitCircles
//
//  Created by B.J. Ray on 8/30/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCCircle.h"
#import "SCSitter.h"
#import "SCUser.h"


@implementation SCCircle

@dynamic circleId;
@dynamic isPrimary;
@dynamic name;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic sitters;
@dynamic user;

- (void)addContactsToSitterList:(NSArray *)contacts {
    SCSittersHelper *sitterHelper = [SCSittersHelper sharedManager];
    self.sitters = [sitterHelper sittersFromContacts:contacts];
}

- (BOOL)containsContact:(id)contact {
    BOOL result = NO;
    SCSittersHelper *sitterHelper = [SCSittersHelper sharedManager];
    result = [sitterHelper sitters:self.sitters containsContact:contact];
    
    return result;
}

@end
