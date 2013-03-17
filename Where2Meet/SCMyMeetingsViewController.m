//
//  SCMyMeetingsViewController.m
//  Where2Meet
//
//  Created by Brandon Lehner on 3/10/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import "SCMyMeetingsViewController.h"
#import "ServiceHub.h"
#import "Meeting.h"
#import "SCAddMeetingViewController.h"

@interface SCMyMeetingsViewController ()

@property (strong, nonatomic) NSArray *myMeetings;

@end

@implementation SCMyMeetingsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshMeetings];
}

// TODO: Add a pull to refresh control to the tableview.
- (void)refreshMeetings
{
    // Network call, do this on a background thread.
    dispatch_queue_t persistentStorageQueue = dispatch_queue_create("apiQueue", NULL);
    dispatch_async(persistentStorageQueue, ^{
        NSArray *downloadedMeetings = [[ServiceHub current] myMeetings];
        
        // Notify the UI to refresh
        dispatch_async(dispatch_get_main_queue(), ^{
            self.myMeetings = downloadedMeetings;
            [self.tableView reloadData];
        });
    });
}

- (NSArray *)myMeetings
{
    if (!_myMeetings) _myMeetings = [[NSArray alloc] init];
    return _myMeetings;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myMeetings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MeetingCell" forIndexPath:indexPath];
    
    NSString *isAttendingText = @"New Invite!";
    
    Meeting *meeting = [self.myMeetings objectAtIndex:indexPath.row];
    if (meeting.isAttending)
    {
        if (meeting.isAttending.intValue == 1)
        {
            isAttendingText = @"Accepted";
        }
        else if (meeting.isAttending.intValue == 0)
        {
            isAttendingText = @"Declined";
        }
    }
    
    cell.textLabel.text = meeting.title;
    cell.detailTextLabel.text = isAttendingText;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MyMeetingsToAddMeeting"])
    {
        if (sender != nil)
        {
            UINavigationController *navController = segue.destinationViewController;
            SCAddMeetingViewController *controller = (SCAddMeetingViewController *)[navController topViewController];
            controller.meetingModel = sender;
        }
    }
}

// Handle what occures when an existing meeting is selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Meeting *selectedMeeting = [self.myMeetings objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier: @"MyMeetingsToAddMeeting" sender:selectedMeeting];
}

- (IBAction)addMeeting:(id)sender
{
    [self performSegueWithIdentifier: @"MyMeetingsToAddMeeting" sender:nil];
}

@end
