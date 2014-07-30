//
//  SCCacheManager.h
//  SitCircles
//
//  Created by B.J. Ray on 7/28/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCUserCache;

@interface SCCacheManager : NSObject
+ (NSString *)userDocPath;
+ (SCUserCache *)loadUserCache;
@end
