//
//  SCInviteeViewController.h
//  Where2Meet
//
//  Created by AllenLin on 3/17/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SCInviteeViewController : UITableViewController <FBFriendPickerDelegate>
- (IBAction)addInvitee:(id)sender;


@end
