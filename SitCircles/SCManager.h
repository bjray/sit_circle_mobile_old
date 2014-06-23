//
//  SCManager.h
//  SitCircles
//
//  Created by B.J. Ray on 6/22/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//
//  Facade singleton that manages data requests
//
//

@import Foundation;

@interface SCManager : NSObject

+(instancetype)sharedManager;
@end
