//
//  SCStartAndEndViewController.m
//  Where2Meet
//
//  Created by Brandon Lehner on 3/10/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import "SCStartAndEndViewController.h"

@interface SCStartAndEndViewController ()

@end

@implementation SCStartAndEndViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.pickerView.date = self.meetingModel.startDateTime;
    [self updateUIFromModel];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)updateUIFromModel
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    formatter.timeZone = destinationTimeZone;
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mma"];
    
    self.startDateLabel.text = [formatter stringFromDate:self.meetingModel.startDateTime];
    self.endDateLabel.text = [formatter stringFromDate:self.meetingModel.endDateTime];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If start date was selected
    if (indexPath.row == 0)
    {
        [self.pickerView setDate:self.meetingModel.startDateTime animated:YES];
    }
    // If end date was selected
    else if (indexPath.row == 1)
    {
        [self.pickerView setDate:self.meetingModel.endDateTime animated:YES];
    }
    // If time zone was selected
    else if (indexPath.row == 2)
    {
        // TODO: handle time zone selection
    }
}

- (IBAction)pickerValueChanged:(id)sender
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];

    // If start date is currently selected
    if (selectedIndexPath.row == 0)
    {
        self.meetingModel.startDateTime = self.pickerView.date;
    }
    
    // If end date is currently selected
    else if (selectedIndexPath.row == 1)
    {
        self.meetingModel.endDateTime = self.pickerView.date;
    }
    
    // Refresh the UI
    [self updateUIFromModel];
}

@end
