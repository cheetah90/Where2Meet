//
//  SCLoginViewController.m
//  Where2Meet
//
//  Created by AllenLin on 3/4/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import "SCLoginViewController.h"
#import "SCAppDelegate.h"

@interface SCLoginViewController ()

- (IBAction)performLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation SCLoginViewController
@synthesize spinner;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)performLogin:(id)sender {
    [self.spinner startAnimating];
    
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         
         switch (state)
         {
             case FBSessionStateOpen:
                 [self performSegueWithIdentifier: @"LoginToLoggedIn" sender:session];
                 break;
             case FBSessionStateClosed:
             case FBSessionStateClosedLoginFailed:
                 // TODO: Handle this case
                 [self loginFailed];
                 break;
             default:
                 break;
         }
         
         //[self sessionStateChanged:session state:state error:error];
     }];
}

- (void)loginFailed{
    [self.spinner stopAnimating];
}

@end
