//
//  SCSessionManagerTests.m
//  SitCircles
//
//  Created by B.J. Ray on 7/27/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SCSessionManager.h"
#import "SCUser.h"

@interface SCSessionManagerTests : XCTestCase
@property (nonatomic, retain) SCSessionManager *manager;
@end

@implementation SCSessionManagerTests

- (void)setUp
{
    [super setUp];
    self.manager = [SCSessionManager sharedManager];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.manager = nil;
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testFetchUserFromCacheOrNetworkIsNil {
    SCUser *user = [self.manager fetchUserFromCacheOrNetwork];
    XCTAssertNil(user, @"User object should be nil");
}

@end
