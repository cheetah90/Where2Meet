//
//  SCInviteesViewController.h
//  Where2Meet
//
//  Created by Brandon Lehner on 3/10/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SCInviteesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FBFriendPickerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addFriends:(id)sender;


@end
