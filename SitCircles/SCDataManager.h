//
//  SCDataManager.h
//  SitCircles
//
//  Created by B.J. Ray on 8/25/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDataManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(instancetype)sharedManager;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
