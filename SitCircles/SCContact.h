//
//  SCContact.h
//  SitCircles
//
//  Created by B.J. Ray on 7/4/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCContact : NSObject
@property (nonatomic)NSInteger uniqueId;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSDictionary *numbers;
@property (nonatomic, retain) UIImage *image;

@property (nonatomic, retain, readonly) NSString *primaryNumberLabel;
@property (nonatomic, retain, readonly) NSString *primaryNumberValue;
@property (nonatomic, retain, readonly) NSString *fullName;
@end