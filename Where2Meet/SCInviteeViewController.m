//
//  SCInviteeViewController.m
//  Where2Meet
//
//  Created by AllenLin on 3/17/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import "SCInviteeViewController.h"
#import "SCInviteeProfileViewController.h"
#import "ServiceHub.h"
#import <FacebookSDK/FacebookSDK.h>

@interface SCInviteeViewController ()
<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (strong, nonatomic) FBGraphObject* currentUserProfile;

@end

@implementation SCInviteeViewController

@synthesize friendPickerController = _friendPickerController;
@synthesize inviteesFBData= _inviteesFBData;
@synthesize currentUserProfile= _currentUserProfile;
@synthesize inviteesAwareness= _inviteesAwareness;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.friendPickerController=nil;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.inviteesFBData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InviteeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString* currentUserName= [[self.inviteesFBData objectAtIndex:indexPath.row] objectForKey:@"name"];

    cell.textLabel.text = currentUserName;
    
    //Populate the awareness
    if ([[self.inviteesAwareness objectAtIndex:indexPath.row] integerValue] == 0) {
        cell.detailTextLabel.text = @"Declined";
    }
    
    else if ([[self.inviteesAwareness objectAtIndex:indexPath.row] integerValue] == 1)
    {
        cell.detailTextLabel.text = @"Accepted";
    }

    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"InviteesList2Profile"])
    {
        SCInviteeProfileViewController *controller = segue.destinationViewController;
        controller.currentUserProfile = self.currentUserProfile;
    }
}

- (void)dealloc
{
    _friendPickerController.delegate = nil;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    self.currentUserProfile = [[self inviteesFBData] objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"InviteesList2Profile" sender:self.currentUserProfile];
}



@end
