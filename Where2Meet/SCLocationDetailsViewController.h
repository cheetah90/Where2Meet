//
//  SCLocationDetailsViewController.h
//  Where2Meet
//
//  Created by Brandon Lehner on 3/23/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCLocationDetailsViewController : UIViewController

@property (nonatomic) int meetingId;
@property (strong, nonatomic) NSString *facebookLocationId;
@property (weak, nonatomic) IBOutlet UILabel *yesVoteCount;
@property (weak, nonatomic) IBOutlet UILabel *noVoteCount;
- (IBAction)voteNoButtonPressed:(id)sender;
- (IBAction)voteYesButtonPressed:(id)sender;

@end
