//
//  SCViewController.h
//  Where2Meet
//
//  Created by AllenLin on 3/4/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SCViewController : UIViewController <FBFriendPickerDelegate>

@property (weak, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
- (IBAction)inviteFBFriends:(id)sender;
@property (strong, nonatomic) NSArray* selectedFriends; //Hold selected friends
@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController; //Hold FBFriendPickerView

@end
