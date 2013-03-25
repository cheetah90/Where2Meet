//
//  SCLocationDetailsViewController.m
//  Where2Meet
//
//  Created by Brandon Lehner on 3/23/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import "SCLocationDetailsViewController.h"
#import "ServiceHub.h"

@interface SCLocationDetailsViewController ()

@end

@implementation SCLocationDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *meetingLocationDetails = [[ServiceHub current] retrieveLocationDetails:self.meetingId faceboolLocationId:self.facebookLocationId];
    
    
}

@end
