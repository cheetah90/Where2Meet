//
//  SCAddMeetingViewController.h
//  Where2Meet
//
//  Created by Brandon Lehner on 3/10/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meeting.h"
#import <FacebookSDK/FacebookSDK.h>

@interface SCAddMeetingViewController : UITableViewController <FBFriendPickerDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *locationbutton;
@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeZoneLabel;
@property (strong, nonatomic) Meeting *meetingModel;
@property (weak, nonatomic) IBOutlet UITableViewCell *deleteButton;


- (IBAction)donePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

- (IBAction)declineButtonPressed:(id)sender;
- (IBAction)acceptButtonPressed:(id)sender;

@end
