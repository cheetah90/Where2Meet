//
//  SCViewController.m
//  Where2Meet
//
//  Created by AllenLin on 3/4/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import "SCViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SCAppDelegate.h"
#import "ServiceHub.h"

@interface SCViewController ()

@end

@implementation SCViewController

@synthesize friendPickerController = _friendPickerController;
@synthesize selectedFriends= _selectedFriends;


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (FBSession.activeSession.isOpen) {
        [self populateUserDetails];
    }
}

- (void)populateUserDetails
{   
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 NSString* userid;
                 self.userNameLabel.text = user.name;
                 userid = user.id;
                 self.userProfileImage.profileID = userid;
                 
                 // Store the facebook userid for future use.
                 ServiceHub *hub = [ServiceHub current];
                 [hub setUserId:userid];
                 
                 // The push notification id can change at any time, so
                 // always register the device at this point.
                 [hub registerUser:userid withDeviceId:[hub deviceId]];
             }
         }];
    }
}

-(void)logoutButtonWasPressed:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    
    // Return to the login view.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Logout"
                                              style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(logoutButtonWasPressed:)];
    
    //[self populateUserDetails];

    // TODO: See if we need this notification handler still?
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:SCSessionStateChangedNotification
     object:nil];
}

- (void)sessionStateChanged:(NSNotification*)notification {
    [self populateUserDetails];
}

- (IBAction)inviteFBFriends:(id)sender {
    //Create instance of FBFriendPicker
    if (!self.friendPickerController) {
        self.friendPickerController = [[FBFriendPickerViewController alloc]
                                       initWithNibName:nil bundle:nil];
        self.friendPickerController.title = @"Select friends";
    }
    
    // Set the friend picker delegate
    self.friendPickerController.delegate = self;
    
    [self.friendPickerController loadData];
    [self.navigationController pushViewController:self.friendPickerController
                                         animated:true];

}

- (void)dealloc
{
    _friendPickerController.delegate = nil;
    self.friendPickerController=nil;
}

- (void)friendPickerViewControllerSelectionDidChange:
(FBFriendPickerViewController *)friendPicker
{
    self.selectedFriends = friendPicker.selection;
    
    //Triggered when friend is selected. Then, app communicates with server: send invitation.
    //friendPicker.selection stores the multiple users in NSArrary, each of them are conformed to FBGraphUser protocol. Refer to https://developers.facebook.com/docs/reference/ios/3.2/protocol/FBGraphUser#id rgarding how to retrieve userid.
    
    
}

@end
