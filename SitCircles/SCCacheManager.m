//
//  SCCacheManager.m
//  SitCircles
//
//  Created by B.J. Ray on 7/28/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCCacheManager.h"
#import "SCUserCache.h"

@implementation SCCacheManager

+ (NSString *)getPrivateDocsDir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
    
}

+ (NSString *)userDocPath {
    NSString *documentsDirectory = [SCCacheManager getPrivateDocsDir];
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    return [documentsDirectory stringByAppendingPathComponent:@"user"];
}

+ (SCUserCache *)loadUserCache {
    SCUserCache *cache = nil;
    
    NSString *documentsDirectory = [SCCacheManager getPrivateDocsDir];
    NSLog(@"Loading userCache from %@", documentsDirectory);
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    if ([files count] == 1) {
        NSString *file = [files objectAtIndex:0];
        if ([file isEqualToString:@"user"]) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:file];
            cache = [[SCUserCache alloc] initWithDocPath:fullPath];
        }
    }
    
    return cache;
}
@end
