//
//  SCLoginViewController.m
//  Where2Meet
//
//  Created by AllenLin on 3/4/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import "SCLoginViewController.h"
#import "SCAppDelegate.h"

@interface SCLoginViewController ()
- (IBAction)performLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation SCLoginViewController
@synthesize spinner;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)performLogin:(id)sender {
    [self.spinner startAnimating];
    
    SCAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
    
}

- (void)loginFailed{
    [self.spinner stopAnimating];
}

@end
