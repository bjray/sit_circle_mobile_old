//
//  SCAcknowledgement.h
//  SitCircles
//
//  Created by B.J. Ray on 12/12/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCSitter;

@interface SCAcknowledgement : NSManagedObject

@property (nonatomic, retain) NSNumber * acknowledgementId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) SCSitter *babysitter;
@property (nonatomic, retain) NSManagedObject *appointment;

@end
