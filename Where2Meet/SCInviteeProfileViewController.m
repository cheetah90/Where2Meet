//
//  SCInviteeProfileViewController.m
//  Where2Meet
//
//  Created by AllenLin on 3/23/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import "SCInviteeProfileViewController.h"

@interface SCInviteeProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *inviteeFirstName;
@property (weak, nonatomic) IBOutlet UILabel *inviteeLastName;
@property (weak, nonatomic) IBOutlet UILabel *inviteeHomeTown;
@property (weak, nonatomic) IBOutlet UILabel *inviteeGender;

@end

@implementation SCInviteeProfileViewController
@synthesize currentUserProfile=_currentUserProfile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Populate those fields
    self.inviteeFirstName.text= [_currentUserProfile objectForKey:@"first_name"];
    self.inviteeLastName.text= [_currentUserProfile objectForKey:@"last_name"];
    self.inviteeHomeTown.text = [[_currentUserProfile objectForKey:@"hometown"] objectForKey:@"name"];
    self.inviteeGender.text= [_currentUserProfile objectForKey:@"gender"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
