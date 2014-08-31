//
//  SCAddressBookDelegate.h
//  SitCircles
//
//  Created by B.J. Ray on 8/30/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SCAddressBookDelegate <NSObject>
- (void)addContactsToSitterList:(NSArray *)contacts;
@end
