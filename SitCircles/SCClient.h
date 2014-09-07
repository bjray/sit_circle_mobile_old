//
//  SCClient.h
//  SitCircles
//
//  Created by B.J. Ray on 6/22/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//
//  Handles calls to the back end
//
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>

@interface SCClient : NSObject

- (instancetype)initWithBaseURL:(NSString *)url;

- (RACSignal *)postJSONData:(NSDictionary *)dict toRelativeURLString:(NSString *) urlString;
- (RACSignal *)fetchJSONFromRelativeURLString:(NSString *)urlString;

@end
