//
//  SCAppDelegate.m
//  SitCircles
//
//  Created by B.J. Ray on 5/6/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import "SCAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SCSessionManager.h"

@implementation SCAppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        NSLog(@"Unable to get user string");
                    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    SCSessionManager *session = [SCSessionManager sharedManager];
    NSArray *fbPermissions = @[@"public_profile",@"email", @"user_friends", @"publish_actions", @"read_friendlists"];
    
    if (session.facebookTokenAvailable) {
        NSLog(@"token is loaded");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:@"rootViewController"];
        [self.window setRootViewController:initViewController];
        [session authenticateUsingFacebookWithPermissions:fbPermissions];
    } else {
        // force login screen...
    }
    
    // TODO: Temp logic - replace with real User object...
    self.user = [[SCUser alloc] init];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
