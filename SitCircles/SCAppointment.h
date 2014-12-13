//
//  SCAppointment.h
//  SitCircles
//
//  Created by B.J. Ray on 12/12/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCAcknowledgement, SCCircle, SCUser;

@interface SCAppointment : NSManagedObject

@property (nonatomic, retain) NSNumber * appointmentId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) SCUser *user;
@property (nonatomic, retain) SCCircle *circle;
@property (nonatomic, retain) NSSet *acknowledgements;
@end

@interface SCAppointment (CoreDataGeneratedAccessors)

- (void)addAcknowledgementsObject:(SCAcknowledgement *)value;
- (void)removeAcknowledgementsObject:(SCAcknowledgement *)value;
- (void)addAcknowledgements:(NSSet *)values;
- (void)removeAcknowledgements:(NSSet *)values;

@end
