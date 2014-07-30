//
//  SCUserCache.h
//  SitCircles
//
//  Created by B.J. Ray on 7/27/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCUser;

@interface SCUserCache : NSObject
@property (nonatomic, copy) NSString *docPath;
@property (nonatomic, retain) SCUser *userData;

- (id)initWithDocPath:(NSString *)docPath;
- (id)initWithUser:(SCUser *)user;
- (BOOL)saveData;
@end
