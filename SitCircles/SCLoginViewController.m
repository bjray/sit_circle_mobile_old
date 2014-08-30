//
//  SCLoginViewController.m
//  SitCircles
//
//  Created by B.J. Ray on 5/26/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//


#import "SCLoginViewController.h"
#import "SCTermsConditionsController.h"
#import "SCAppDelegate.h"
#import "SCSessionManager.h"
#import <TSMessages/TSMessage.h>

@interface SCLoginViewController () <FBLoginViewDelegate>

@end

@implementation SCLoginViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        NSLog(@"Init method fired...");
        
    }
    
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SCSessionManager *session = [SCSessionManager sharedManager];
    NSArray *fbPermissions = @[@"public_profile",@"email", @"user_friends", @"publish_actions", @"read_friendlists"];
    
    if (session.facebookTokenAvailable) {
        NSLog(@"token is loaded");
        
        [[session authenticateUsingFacebookWithPermissions:fbPermissions] subscribeError:^(NSError *error) {
            NSLog(@"sendError");
            NSLog(@"DAMN IT!!!");
        } completed:^{
            NSLog(@"sendComplete");
            NSLog(@"ALL GOOD!!!!");
            [session loadUserFromCacheOrNetwork];
            
            
            [self displayHomePage];
        }];        
    } else {
        self.backgroundImageView.hidden = NO;
        [self.activityIndicator stopAnimating];
        self.welcomeLabel.hidden = YES;
        
        // Create Login View so that the app will be granted "status_update" permission.
        FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:fbPermissions];
        
        loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width /2)), (self.view.frame.size.height - (loginView.frame.size.height * 3)));
        //self.view.frame.size.height - (loginView.frame.size.height *2)
        //self.view.center.y - (loginView.frame.size.height /2)
        loginView.delegate = self;
        
        [self.view addSubview:loginView];
        [loginView sizeToFit];
        
        if (FBSession.activeSession.state == FBSessionStateOpen) {
            loginView.hidden = YES;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)displayHomePage {
    SCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate loadRoot];
    NSLog(@"did it present?");
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = [segue destinationViewController];
    NSLog(@"destination: %@", destination);
    
}



#pragma mark - FBLoginViewDelegate
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"user: %@", user);
    NSLog(@"fb token: %@", FBSession.activeSession.accessTokenData);
    
    SCSessionManager *session = [SCSessionManager sharedManager];
    [session loadUserFromCacheOrNetworkByFBUser:user fbToken:FBSession.activeSession.accessTokenData.accessToken];
    
    [self displayHomePage];
    
    //using the fbuser, check to see if we have a matching user on the device
    // If YES
    //      - follow normal process of login...
    // If NO
    //      - Create user on server (async)
    //      - Create user's default circle on server (async)
    //      - create user locally

}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"FBLoginView: %@", loginView);
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    //TODO
    NSLog(@"handle this someday");
}

- (void)loadUser {
    NSLog(@"what about this?");
}

@end
