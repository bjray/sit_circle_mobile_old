//
//  SCCircle.m
//  SitCircles
//
//  Created by B.J. Ray on 7/4/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCCircle.h"
#import "SCSitters.h"
//#import "SCAppDelegate.h"
#import "SCSittersHelper.h"

@implementation SCCircle
@synthesize sitters = _sitters;
@synthesize ownerId = _ownerId;
@synthesize name = _name;

- (id)init {
//    SCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    NSString *ownerId =  appDelegate.user.fbId;
    
    return [self initCircleWithName:@"My Circle" sitters:nil ownerId:nil];
}

- (id)initCircleWithName:(NSString *)name sitters:(NSArray *)sitterArray ownerId:(NSString *)ownerId {
    self = [super init];
    if (self) {
        _sitters = sitterArray;
        _name = name;
        _ownerId = ownerId;
    }
    
    return self;
}

- (void)addSitter:(__autoreleasing id<SCSitters> *)sitter {
    
}

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

#pragma mark - Archiving logic

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    NSString *name = [aDecoder decodeObjectForKey:@"name"];
    NSString *ownerId = [aDecoder decodeObjectForKey:@"ownerId"];
    NSArray *sitters = [aDecoder decodeObjectForKey:@"sitters"];    //should work as long as a sitter can be decoded
    
    return [self initCircleWithName:name sitters:sitters ownerId:ownerId];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.ownerId forKey:@"ownerId"];
    [aCoder encodeObject:self.sitters forKey:@"sitters"];           //should work as long as a sitter can be encoded

}

@end
