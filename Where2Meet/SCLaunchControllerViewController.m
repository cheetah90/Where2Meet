//
//  SCLaunchControllerViewController.m
//  Where2Meet
//
//  Created by Brandon Lehner on 3/10/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import "SCLaunchControllerViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SCViewController.h"

@implementation SCLaunchControllerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self openSession];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Hide the navbar control on this page so it is not visible.
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         
         switch (state)
         {
             case FBSessionStateOpen:
                 [self performSegueWithIdentifier: @"LaunchToLoggedIn" sender:session];
                 break;
             default:
                 [self performSegueWithIdentifier: @"LaunchToLogin" sender:session];
                 break;
         }
     }];
}

//- (void)sessionStateChanged:(FBSession *)session
//                      state:(FBSessionState) state
//                      error:(NSError *)error
//{
//    switch (state) {
//        case FBSessionStateOpen: {
//            UIViewController *topViewController =
//            [self.navController topViewController];
//            if ([[topViewController presentedViewController]
//                 isKindOfClass:[SCLoginViewController class]]) {
//                [topViewController dismissViewControllerAnimated:YES completion:NULL];
//            }
//        }
//            break;
//        case FBSessionStateClosed:
//        case FBSessionStateClosedLoginFailed:
//            // Once the user has logged in, we want them to
//            // be looking at the root view.
//            [self.navController popToRootViewControllerAnimated:NO];
//            
//            [FBSession.activeSession closeAndClearTokenInformation];
//            
//            [self showLoginView];
//            break;
//        default:
//            break;
//    }
//    
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:SCSessionStateChangedNotification
//     object:session];
//    
//    if (error) {
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Error"
//                                  message:error.localizedDescription
//                                  delegate:nil
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil];
//        [alertView show];
//    }
//}


@end
