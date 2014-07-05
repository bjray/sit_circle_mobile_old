//
//  SCLoginViewController.m
//  SitCircles
//
//  Created by B.J. Ray on 5/26/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

@import CoreLocation;
#import "SCLoginViewController.h"
#import "SCTermsConditionsController.h"
#import "SCAppDelegate.h"


@interface SCLoginViewController () <FBLoginViewDelegate>

@end

@implementation SCLoginViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        NSLog(@"Init method fired...");
        
    }
    
    
    return self;
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    if (FBSession.activeSession.state == FBSessionStateOpen) {
        NSLog(@"we have a cached user!");
        
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // Success! Include your code to handle the results here
                SCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                [appDelegate.user facebookUser:result withToken:FBSession.activeSession.accessTokenData.accessToken];
                
                
//                NSLog(@"user info: %@", result);
//                NSMutableDictionary<FBOpenGraphObject> *myObject = result;
//
//                NSLog(@"fb token: %@", FBSession.activeSession.accessTokenData);
                [self performSegueWithIdentifier:@"TabBarSegue" sender:self];
            } else {
                // An error occurred, we need to handle the error
                // See: https://developers.facebook.com/docs/ios/errors
            }
        }];
        

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Create Login View so that the app will be granted "status_update" permission.
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile",@"email", @"user_friends", @"publish_actions", @"read_friendlists"]];
    
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width /2)), (self.view.center.y - (loginView.frame.size.height /2)));
    loginView.delegate = self;
    
    [self.view addSubview:loginView];
    [loginView sizeToFit];
    
    if (FBSession.activeSession.state == FBSessionStateOpen) {
        loginView.hidden = YES;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = [segue destinationViewController];
    NSLog(@"destination: %@", destination);
    // Get the new view controller using [segue destinationViewController].
//    UINavigationController *navVC = [segue destinationViewController];
//    NSLog(@"navVC: %@", navVC);
//    SCTermsConditionsController *tcVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TermsConditionsController"];
    
}



#pragma mark - FBLoginViewDelegate
//for some reason, this method is called twice...
//- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
//                            user:(id<FBGraphUser>)user {
//    NSLog(@"user: %@", user);
//    NSLog(@"fb token: %@", FBSession.activeSession.accessTokenData);
////    [self performSegueWithIdentifier:@"showTCs" sender:self];
//}

//- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
//    NSLog(@"FBLoginView: %@", loginView);
//}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    //TODO
    NSLog(@"handle this someday");
}

@end
