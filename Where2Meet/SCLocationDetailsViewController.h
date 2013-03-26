//
//  SCLocationDetailsViewController.h
//  Where2Meet
//
//  Created by Brandon Lehner on 3/23/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCLocationDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic) int meetingId;
@property (strong, nonatomic) NSString *facebookLocationId;
@property (strong, nonatomic) NSString *locationName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)voteNoButtonPressed:(id)sender;
- (IBAction)voteYesButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end
