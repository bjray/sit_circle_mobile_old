//
//  SCCircle.m
//  SitCircles
//
//  Created by B.J. Ray on 7/4/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCCircle.h"
#import "SCSitters.h"
#import "SCAppDelegate.h"

@implementation SCCircle
@synthesize sitters = _sitters;
@synthesize ownerId = _ownerId;
@synthesize name = _name;

- (id)init {
    SCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *ownerId =  appDelegate.user.fbId;
    
    return [self initCircleWithName:@"My Circle" sitters:nil ownerId:ownerId];
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

@end
