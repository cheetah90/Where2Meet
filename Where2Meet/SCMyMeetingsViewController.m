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

@interface SCMyMeetingsViewController ()

@property (strong, nonatomic) ServiceHub *serviceHub;
@property (strong, nonatomic) NSArray *myMeetings;

@end

@implementation SCMyMeetingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshMeetings];
}

// TODO: Add a pull to refresh control to the tableview.
- (void)refreshMeetings
{
    // Network call, do this on a background thread.
    dispatch_queue_t persistentStorageQueue = dispatch_queue_create("apiQueue", NULL);
    dispatch_async(persistentStorageQueue, ^{
        self.myMeetings = [self.serviceHub myMeetings];
    });
}

- (ServiceHub *)serviceHub
{
    if (!_serviceHub) _serviceHub = [[ServiceHub alloc] init];
    return _serviceHub;
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
    
    Meeting *meeting = [self.myMeetings objectAtIndex:indexPath.row];
    cell.textLabel.text = meeting.title;
    return cell;
}

@end
