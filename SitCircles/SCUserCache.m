//
//  SCUserCache.m
//  SitCircles
//
//  Created by B.J. Ray on 7/27/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCUserCache.h"

@implementation SCUserCache


+ (NSString *)getPrivateDocsDir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
    
}

+ (NSString *)userDocPath {
    NSString *documentsDirectory = [SCUserCache getPrivateDocsDir];
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    return [documentsDirectory stringByAppendingPathComponent:@"user"];
}
@end
