//
//  SCStartAndEndViewController.h
//  Where2Meet
//
//  Created by Brandon Lehner on 3/10/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meeting.h"

@interface SCStartAndEndViewController : UITableViewController

@property (strong, nonatomic) Meeting *meetingModel;

@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeZoneLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;
- (IBAction)pickerValueChanged:(id)sender;

@end
