//
//  SCSitters.h
//  SitCircles
//
//  Created by B.J. Ray on 7/4/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCSitters <NSObject>
@property (nonatomic, copy) NSString *sitterId;
@property (nonatomic) NSInteger addressBookId;          //Zero means no id
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSDictionary *numbers;
@property (nonatomic, copy) NSDictionary *emails;
@property (nonatomic, retain) UIImage *image;

@property (nonatomic, retain) NSString *primaryNumberLabel;
@property (nonatomic, retain) NSString *primaryNumberValue;
@property (nonatomic, retain) NSString *primaryEmailLabel;
@property (nonatomic, retain) NSString *primaryEmailValue;

@property (nonatomic, retain, readonly) NSString *fullName;
@end
