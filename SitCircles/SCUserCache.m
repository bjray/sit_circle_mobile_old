//
//  SCUserCache.m
//  SitCircles
//
//  Created by B.J. Ray on 7/27/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCUserCache.h"
#import "SCUser.h"
#import "SCCacheManager.h"

#define kDataFile       @"user.plist"
#define kDataKey        @"Data"

@implementation SCUserCache

- (id)init {
    return [self initWithDocPath:nil];
}

- (id)initWithDocPath:(NSString *)docPath {
    if ((self = [super init])) {
        _docPath = [docPath copy];
    }
    return self;
}

- (id)initWithUser:(SCUser *)user {
    if ((self = [super init])) {
        self.userData = user;
    }
    
    return self;
}

- (SCUser *)userData {
    
    if (_userData != nil) return _userData;
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) return nil;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    _userData = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];
    
    return _userData;
}

- (BOOL)saveData {
    BOOL result = NO;
    if ((self.userData != nil) && [self createDataPath]) {
        
        NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:_userData forKey:kDataKey];
        [archiver finishEncoding];
        [data writeToFile:dataPath atomically:YES];
        result = YES;
    }
    
    return result;
}

- (BOOL)createDataPath {
    
    if (_docPath == nil) {
        self.docPath = [SCCacheManager userDocPath];
    }
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:_docPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return success;
}

@end
