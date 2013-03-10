//
//  SCAddMeetingViewController.m
//  Where2Meet
//
//  Created by Brandon Lehner on 3/10/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import "SCAddMeetingViewController.h"
#import "Meeting.h"
#import "SCStartAndEndViewController.h"

@interface SCAddMeetingViewController ()

@property (strong, nonatomic) Meeting *meetingModel;

@end

@implementation SCAddMeetingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    formatter.timeZone = destinationTimeZone;
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mma"];
    
    self.startDateTimeLabel.text = [formatter stringFromDate:self.meetingModel.startDateTime];
    self.endDateTimeLabel.text = [formatter stringFromDate:self.meetingModel.endDateTime];
    self.timeZoneLabel.text = @"Chicago"; // TODO: Add in timezone properly
}

- (Meeting *)meetingModel
{
    if (!_meetingModel) _meetingModel = [[Meeting alloc] init];
    return _meetingModel;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddMeetingToStartAndEnd"])
    {
        SCStartAndEndViewController *controller = segue.destinationViewController;
        controller.meetingModel = self.meetingModel;
    }
}

@end
