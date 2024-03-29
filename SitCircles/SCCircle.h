//
//  SCCircle.h
//  SitCircles
//
//  Created by B.J. Ray on 12/12/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCAppointment, SCSitter, SCUser;

@interface SCCircle : NSManagedObject

@property (nonatomic, retain) NSNumber * circleId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * isPrimary;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *sitters;
@property (nonatomic, retain) SCUser *user;
@property (nonatomic, retain) NSSet *appointments;
@end

@interface SCCircle (CoreDataGeneratedAccessors)

- (void)addSittersObject:(SCSitter *)value;
- (void)removeSittersObject:(SCSitter *)value;
- (void)addSitters:(NSSet *)values;
- (void)removeSitters:(NSSet *)values;

- (void)addAppointmentsObject:(SCAppointment *)value;
- (void)removeAppointmentsObject:(SCAppointment *)value;
- (void)addAppointments:(NSSet *)values;
- (void)removeAppointments:(NSSet *)values;

@end
