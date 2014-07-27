//
//  SCCircle.h
//  SitCircles
//
//  Created by B.J. Ray on 7/4/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCCircles.h"

@interface SCCircle : NSObject <SCCircles>
- (id)initCircleWithName:(NSString *)name sitters:(NSArray *)sitterArray ownerId:(NSString *)ownerId;
@end
