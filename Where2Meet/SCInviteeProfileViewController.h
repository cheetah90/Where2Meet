//
//  SCInviteeProfileViewController.h
//  Where2Meet
//
//  Created by AllenLin on 3/23/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SCInviteeProfileViewController : UIViewController
@property (strong, nonatomic) FBGraphObject* currentUserProfile;

@end
