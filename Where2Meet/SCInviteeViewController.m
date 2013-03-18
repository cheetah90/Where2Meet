//
//  SCInviteeViewController.m
//  Where2Meet
//
//  Created by AllenLin on 3/17/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import "SCInviteeViewController.h"
#import "ServiceHub.h"

@interface SCInviteeViewController ()
@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (strong, nonatomic) NSArray* selectedFriends;
@property (strong, nonatomic) NSArray *friendwithApp;

@end

@implementation SCInviteeViewController

@synthesize friendPickerController = _friendPickerController;
@synthesize selectedFriends = _selectedFriends;


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
    
    //Request for my friends who registered our app
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
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

- (IBAction)addInvitee:(id)sender {
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
    [self presentViewController:self.friendPickerController animated:NO completion:nil];

}

- (void)dealloc
{
    _friendPickerController.delegate = nil;
}

- (void)friendPickerViewControllerSelectionDidChange:
(FBFriendPickerViewController *)friendPicker
{
    self.selectedFriends = friendPicker.selection;
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


@end
