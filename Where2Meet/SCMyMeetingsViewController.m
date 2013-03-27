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

@property (strong, nonatomic) NSArray *groupedMeetings;

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
        
        // Sort the meeting data
        NSArray *sortedMeetings = [downloadedMeetings sortedArrayUsingComparator:^NSComparisonResult(Meeting *obj1, Meeting *obj2)
        {
            return [[obj1 startDateTime] compare:[obj2 startDateTime]];
        }];
        
        // Group the meeting data by day
        NSMutableArray *groupedMeetings = [[NSMutableArray alloc] init];
        NSDate *prevDate;
        NSMutableArray *currentDayGrouping = [[NSMutableArray alloc] init];
        
        for (Meeting *meeting in sortedMeetings)
        {
            unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [calendar components:flags fromDate:meeting.startDateTime];
            
            NSDate* dateOnly = [calendar dateFromComponents:components];
            if (prevDate)
            {
                // If the dates are equal, keep them in the same group
                if ([dateOnly compare:prevDate] != 0)
                {
                    [groupedMeetings addObject:currentDayGrouping];
                    currentDayGrouping =[[NSMutableArray alloc] init];
                }
            }
            
            [currentDayGrouping addObject:meeting];
            prevDate = dateOnly;
        }
        
        if (currentDayGrouping.count > 0)
        {
            [groupedMeetings addObject:currentDayGrouping];
        }
        
        // Notify the UI to refresh
        dispatch_async(dispatch_get_main_queue(), ^{
            //self.myMeetings = sortedMeetings;
            self.groupedMeetings = groupedMeetings;
            [self.tableView reloadData];
        });
    });
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *meetingsForDay = [self.groupedMeetings objectAtIndex:section];
    Meeting *meeting = [meetingsForDay objectAtIndex:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    formatter.timeZone = destinationTimeZone;
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:@"MMM dd YYYY"];
    
    return [formatter stringFromDate:meeting.startDateTime];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupedMeetings.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *meetingsForDay = [self.groupedMeetings objectAtIndex:section];
    return meetingsForDay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MeetingCell" forIndexPath:indexPath];
    
    NSString *isAttendingText = @"New Invite!";
    
    NSArray *meetingsForDay = [self.groupedMeetings objectAtIndex:indexPath.section];
    Meeting *meeting = [meetingsForDay objectAtIndex:indexPath.row];
    
    //Meeting *meeting = [self.myMeetings objectAtIndex:indexPath.row];
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
    //Meeting *selectedMeeting = [self.myMeetings objectAtIndex:indexPath.row];
    NSArray *meetingsForDay = [self.groupedMeetings objectAtIndex:indexPath.section];
    Meeting *meeting = [meetingsForDay objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier: @"MyMeetingsToAddMeeting" sender:meeting];
}

- (IBAction)addMeeting:(id)sender
{
    [self performSegueWithIdentifier: @"MyMeetingsToAddMeeting" sender:nil];
}

@end
