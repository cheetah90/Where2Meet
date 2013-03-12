//
//  SCInviteesViewController.m
//  Where2Meet
//
//  Created by Brandon Lehner on 3/10/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import "SCInviteesViewController.h"

@interface SCInviteesViewController ()

@end

@implementation SCInviteesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"InviteeCell" forIndexPath:indexPath];
    
    //cell.textLabel.text = meeting.title;
    return cell;
}

@end
