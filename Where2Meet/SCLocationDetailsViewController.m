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
#import "SCLocationVoteCell.h"
#import "SCLocationCommentCell.h"
#import "SCLocationNameCell.h"

@interface SCLocationDetailsViewController ()

@property (strong, nonatomic) NSArray *meetingLocationDetails;
@property (nonatomic) int yesCount;
@property (nonatomic) int noCount;
@property (strong, nonatomic) NSArray *comments;

@end

@implementation SCLocationDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}

- (void)loadData
{
    self.meetingLocationDetails = [[ServiceHub current] retrieveLocationDetails:self.meetingId faceboolLocationId:self.facebookLocationId];
    
    self.yesCount = 0;
    self.noCount = 0;
    NSMutableArray *comments = [[NSMutableArray alloc] init];
    
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
        
        if (locationDetails.comments)
        {
            [comments addObjectsFromArray:locationDetails.comments];
        }
    }
    
    self.comments = comments;
    [self.tableView reloadData];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0)
    {
        SCLocationNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationNameCell" forIndexPath:indexPath];
        cell.locationNameLabel.text = self.locationName;
        return cell;
    }
    else if (indexPath.row == 1 && indexPath.section == 0)
    {
        SCLocationVoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VoteCell" forIndexPath:indexPath];
        cell.locationVoteLabel.text = [NSString stringWithFormat:@"%d Yes - %d No", self.yesCount, self.noCount];
        return cell;
    }
    else
    {
        SCLocationCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
        cell.locationCommentLabel.text = [self.comments objectAtIndex:indexPath.row];
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return @"Comments";
    }
    
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 1)
    {
        return 44;
    }
    
    return 96;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else
    {
        return self.comments.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self moveTextViewForKeyboard:aNotification up:NO];
}

- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up{
    NSDictionary* userInfo = [aNotification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    // Animate up or down
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.toolbar.frame;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    
    newFrame.origin.y -= keyboardFrame.size.height * (up? 1 : -1);
    self.toolbar.frame = newFrame;
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Post the comment
    [[ServiceHub current] commentOnLocation:self.meetingId facebookLocationId:self.facebookLocationId comment:textField.text];
    
    // Reload data
    [self loadData];
    
    // Clear out the text field.
    textField.text = @"";
    
    // Start hiding the keyboard.
    [textField resignFirstResponder];
    return NO;
}

@end
