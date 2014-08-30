//
//  SCCircle.h
//  SitCircles
//
//  Created by B.J. Ray on 8/25/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCSitter, SCUser;

@interface SCCircle : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) int32_t circleId;
@property (nonatomic) BOOL isPrimary;
@property (nonatomic, retain) SCUser *user;
@property (nonatomic, retain) NSSet *sitters;
@end

@interface SCCircle (CoreDataGeneratedAccessors)

- (void)addSittersObject:(SCSitter *)value;
- (void)removeSittersObject:(SCSitter *)value;
- (void)addSitters:(NSSet *)values;
- (void)removeSitters:(NSSet *)values;

@end
