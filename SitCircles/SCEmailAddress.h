//
//  SCEmailAddress.h
//  SitCircles
//
//  Created by B.J. Ray on 8/25/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCSitter;

@interface SCEmailAddress : NSManagedObject

@property (nonatomic) BOOL isPrimary;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) SCSitter *sitter;

@end
