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
#import "ServiceHub.h"

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
    [formatter setDateFormat:@"MMM dd h:mm a"];
    
    self.startDateTimeLabel.text = [formatter stringFromDate:self.meetingModel.startDateTime];
    self.endDateTimeLabel.text = [formatter stringFromDate:self.meetingModel.endDateTime];
    self.timeZoneLabel.text = @"Chicago"; // TODO: Add in timezone properly
    self.titleLabel.text = self.meetingModel.title;
}

- (Meeting *)meetingModel
{
    if (!_meetingModel) _meetingModel = [[Meeting alloc] init];
    return _meetingModel;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.meetingModel.title = self.titleLabel.text;
    
    if ([segue.identifier isEqualToString:@"AddMeetingToStartAndEnd"])
    {
        SCStartAndEndViewController *controller = segue.destinationViewController;
        controller.meetingModel = self.meetingModel;
    }
}

- (IBAction)donePressed:(id)sender
{
    // Save the meeting by calling the service.
    [[ServiceHub current] createMeetingWithTitle:self.titleLabel.text
                                   withStartDate:self.meetingModel.startDateTime
                                     withEndDate:self.meetingModel.endDateTime
                                     withFriends:self.meetingModel.invitees];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
