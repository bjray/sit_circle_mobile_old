//
//  SCCircles.h
//  SitCircles
//
//  Created by B.J. Ray on 7/4/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCSitters.h"

@protocol SCCircles <NSObject>
@property (nonatomic, retain) NSArray *sitters;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *ownerId;

- (void)addSitter:(id<SCSitters>*)sitter;
- (void)addContactsToSitterList:(NSArray *)contacts;
- (BOOL)containsContact:(id)contact;
@end
