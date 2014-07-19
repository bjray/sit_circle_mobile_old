//
//  SCSittersHelper.h
//  SitCircles
//
//  Created by B.J. Ray on 7/19/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import "SCSitter.h"
#import "SCContact.h"

@interface SCSittersHelper : NSObject
+(instancetype)sharedManager;


//- (NSString *)saveSitter:(SCSitter *)sitter forCircleId:(NSString *)circleId;
- (SCSitter *)sitterFromContact:(SCContact *)contact;
- (NSMutableArray *)sittersFromContacts:(NSArray *)contacts;
@end
