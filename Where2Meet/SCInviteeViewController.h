//
//  SCInviteeViewController.h
//  Where2Meet
//
//  Created by AllenLin on 3/17/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Meeting.h"

@interface SCInviteeViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *InviteeTableView;
@property (strong, nonatomic) NSMutableArray* inviteesFBData;

@end
