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

@end

@implementation SCLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
