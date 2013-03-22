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

@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (nonatomic, strong) NSMutableArray* selectedFriends;
@property (nonatomic) BOOL isNew;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *friendwithApp;

@end

@implementation SCAddMeetingViewController
@synthesize friendwithApp=_friendwithApp;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMyFriends] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary *friendslist,
           NSError *error) {
             if (!error) {
                 NSDictionary<FBGraphUser>* friend;
                 //Store user's complete friends userids
                 NSMutableArray* friends_fbuserid=[[NSMutableArray alloc] init];
                 
                 for (friend in [friendslist objectForKey:@"data"] ) {
                     [friends_fbuserid addObject:friend.id];
                 }
                 
                 // Store the facebook userid for future use.
                 ServiceHub *hub = [ServiceHub current];
                 
                 // Retrieve those FB friends who have registered at Where2Meet
                 self.friendwithApp = [hub friendsWithApp:friends_fbuserid];
                 
             }
         }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.meetingModel || self.isNew)
    {
        self.isNew = YES;
        self.meetingModel = [[Meeting alloc] init];
        self.deleteButton.hidden = YES;
        self.locationbutton.hidden = YES;
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
        case 0:
            if (self.isNew) {
                if (!self.friendPickerController) {
                    self.friendPickerController = [[FBFriendPickerViewController alloc]
                                                   initWithNibName:nil bundle:nil];
                }
                
                // Set the friend picker delegate
                self.friendPickerController.delegate = self;
                
                // Ask for friend device data
                self.friendPickerController.fieldsForRequest = [NSSet setWithObjects:@"devices", nil];
                
                self.friendPickerController.title = @"Select friends";
                
                // Ask for friend id data
                self.friendPickerController.fieldsForRequest = [NSSet setWithObjects:@"id", nil];
                
                //Load data
                [self.friendPickerController loadData];
                [self presentViewController:self.friendPickerController animated:YES completion:nil];
            }
            
        
        default:
            break;
    }

}

- (IBAction)donePressed:(id)sender
{
    self.meetingModel.title = self.titleLabel.text;
    self.meetingModel.invitees = self.selectedFriends;
    
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

- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUser>)user
{
    NSString* friend_id= user.id;
    
    if ([self.friendwithApp indexOfObject:friend_id] != NSNotFound) {
        return YES;
    }
    
    else return NO;
}


//These two functions are dealing with facebook friends pickers 
- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    self.selectedFriends=nil;
    
    [self.friendPickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    NSArray* selection= self.friendPickerController.selection;
    NSMutableArray* tpselectedFriend= [[NSMutableArray alloc] init];
    NSDictionary<FBGraphUser>* friend;
    //Store user's complete friends userids

    for (friend in selection)
    {
        [tpselectedFriend addObject:friend.id];
    }
 
    self.selectedFriends=tpselectedFriend;
    [self.friendPickerController dismissViewControllerAnimated:YES completion:nil];
    
    
}


//Hide the segue when creating a meeting
- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqual: @"SegueInviteeViewController"] && self.isNew == YES) {
        return NO;
    }
    return YES;
}

@end
