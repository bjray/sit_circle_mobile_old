//
//  SCUser.h
//  SitCircles
//
//  Created by B.J. Ray on 12/12/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCAppointment, SCCircle;

@interface SCUser : NSManagedObject
//generated properties...
@property (nonatomic, retain) NSString * fbAccessToken;
@property (nonatomic, retain) NSString * fbID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSDate * lastNetworkLoad;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSSet *circles;
@property (nonatomic, retain) NSSet *appointments;

//added properties...
@property (nonatomic, retain, readonly) SCCircle* primaryCircle;
@end

@interface SCUser (CoreDataGeneratedAccessors)
//generated methods...
- (void)addCirclesObject:(SCCircle *)value;
- (void)removeCirclesObject:(SCCircle *)value;
- (void)addCircles:(NSSet *)values;
- (void)removeCircles:(NSSet *)values;

- (void)addAppointmentsObject:(SCAppointment *)value;
- (void)removeAppointmentsObject:(SCAppointment *)value;
- (void)addAppointments:(NSSet *)values;
- (void)removeAppointments:(NSSet *)values;

//added methods...
- (NSDictionary *)userAsDictionary;
@end
