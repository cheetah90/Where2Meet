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
#import <CoreLocation/CoreLocation.h>

@interface SCAddMeetingViewController ()

@property (nonatomic) BOOL isNew;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation SCAddMeetingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.meetingModel || self.isNew)
    {
        self.isNew = YES;
        self.meetingModel = [[Meeting alloc] init];
        self.deleteButton.hidden = YES;
    }
    else
    {
        self.navigationController.toolbarHidden = NO;
        self.navigationController.navigationBar.topItem.title = @"Meeting Details";
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (NSString *)deviceLocation
{
    return [NSString stringWithFormat:@"%f,%f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
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
                                         withFriends:self.meetingModel.invitees
                                         withGeoCode:[self deviceLocation]];
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

- (IBAction)declineButtonPressed:(id)sender
{
    [[ServiceHub current] respondToMeetingInvite:self.meetingModel.meetingId
                                        accepted:NO
                                     withGeoCode:[self deviceLocation]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)acceptButtonPressed:(id)sender
{
    [[ServiceHub current] respondToMeetingInvite:self.meetingModel.meetingId
                                        accepted:YES
                                     withGeoCode:[self deviceLocation]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
