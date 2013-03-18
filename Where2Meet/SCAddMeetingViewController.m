//
//  SCAddMeetingViewController.m
//  Where2Meet
//
//  Created by Brandon Lehner on 3/10/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import "SCAddMeetingViewController.h"
#import "SCStartAndEndViewController.h"
#import "ServiceHub.h"


@interface SCAddMeetingViewController ()

@property (nonatomic) BOOL isNew;

@end

@implementation SCAddMeetingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.meetingModel)
    {
        self.isNew = YES;
        self.meetingModel = [[Meeting alloc] init];
        self.deleteButton.hidden = YES;
    }
    else
    {
        self.navigationController.toolbarHidden = NO;
        self.navigationController.navigationBar.topItem.title = @"Meeting Details";
        
        // If this is the meeting creator, give them the option to cancel the meeting
        //if (self.meetingModel.isCreator)
        {
            
        }
        // If this user is not the creator if the meeting, give them the options to accept or decline the meeting
        //else
        {
            
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    formatter.timeZone = destinationTimeZone;
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:@"MMM dd h:mm a"];
    
    self.startDateTimeLabel.text = [formatter stringFromDate:self.meetingModel.startDateTime];
    self.endDateTimeLabel.text = [formatter stringFromDate:self.meetingModel.endDateTime];
    self.timeZoneLabel.text = @"Chicago"; // TODO: Add in timezone properly
    self.titleLabel.text = self.meetingModel.title;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        default:
            break;
    }

}

- (IBAction)donePressed:(id)sender
{
    self.meetingModel.title = self.titleLabel.text;
    
    if (self.isNew)
    {
        // Save the meeting by calling the service.
        [[ServiceHub current] createMeetingWithTitle:self.meetingModel.title
                                       withStartDate:self.meetingModel.startDateTime
                                         withEndDate:self.meetingModel.endDateTime
                                         withFriends:self.meetingModel.invitees];
    }
    else
    {
        [[ServiceHub current] updateMeetingWithMeetingId:self.meetingModel.meetingId
                                               withTitle:self.meetingModel.title
                                           withStartDate:self.meetingModel.startDateTime
                                             withEndDate:self.meetingModel.endDateTime
                                             withFriends:self.meetingModel.invitees];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
