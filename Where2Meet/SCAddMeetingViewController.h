//
//  SCAddMeetingViewController.h
//  Where2Meet
//
//  Created by Brandon Lehner on 3/10/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCAddMeetingViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeZoneLabel;

@end
