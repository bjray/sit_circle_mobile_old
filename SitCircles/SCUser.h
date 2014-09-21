//
//  SCUser.h
//  SitCircles
//
//  Created by B.J. Ray on 8/25/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCCircle;

@interface SCUser : NSManagedObject

@property (nonatomic, retain) NSDate * lastNetworkLoad;
@property (nonatomic, retain) NSString * fbAccessToken;
@property (nonatomic, retain) NSString * fbID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSSet *circles;
@property (nonatomic, retain, readonly) SCCircle* primaryCircle;
@end

@interface SCUser (CoreDataGeneratedAccessors)

- (void)addCirclesObject:(SCCircle *)value;
- (void)removeCirclesObject:(SCCircle *)value;
- (void)addCircles:(NSSet *)values;
- (void)removeCircles:(NSSet *)values;

- (NSDictionary *)userAsDictionary;

@end
