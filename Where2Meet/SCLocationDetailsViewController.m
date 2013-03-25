//
//  SCLocationDetailsViewController.m
//  Where2Meet
//
//  Created by Brandon Lehner on 3/23/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import "SCLocationDetailsViewController.h"
#import "ServiceHub.h"
#import "LocationDetails.h"

@interface SCLocationDetailsViewController ()

@property (strong, nonatomic) NSArray *meetingLocationDetails;
@property (nonatomic) int yesCount;
@property (nonatomic) int noCount;

@end

@implementation SCLocationDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
}

- (void)loadData
{
    self.meetingLocationDetails = [[ServiceHub current] retrieveLocationDetails:self.meetingId faceboolLocationId:self.facebookLocationId];
    
    self.yesCount = 0;
    self.noCount = 0;
    for (LocationDetails *locationDetails in self.meetingLocationDetails)
    {
        if (locationDetails.vote == -1)
        {
            self.noCount++;
        }
        else if (locationDetails.vote == 1)
        {
            self.yesCount++;
        }
        
        // TODO: Display comments...
    }
    
    self.yesVoteCount.text = [NSString stringWithFormat:@"%d", self.yesCount];
    self.noVoteCount.text = [NSString stringWithFormat:@"%d", self.noCount];
}

- (IBAction)voteNoButtonPressed:(id)sender
{
    [[ServiceHub current] voteOnLocation:self.meetingId facebookLocationId:self.facebookLocationId vote:-1];
    [self loadData];
}

- (IBAction)voteYesButtonPressed:(id)sender
{
    [[ServiceHub current] voteOnLocation:self.meetingId facebookLocationId:self.facebookLocationId vote:1];
    [self loadData];
}

@end
