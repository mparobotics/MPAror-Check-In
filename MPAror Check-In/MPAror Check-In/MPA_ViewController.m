//
//  MPA_ViewController.m
//  MPAror Check-In
//
//  Created by Brendan Boyle on 1/19/14.
//  Copyright (c) 2014 MPAror Robotics. All rights reserved.
//

#import "MPA_ViewController.h"
#import "MPA_ScanController.h"

@interface MPA_ViewController ()

@end

@implementation MPA_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toscan"]){
        MPA_ScanController *controller = (MPA_ScanController *)segue.destinationViewController;
        controller.mode = [_modeToggle selectedSegmentIndex];
    }
}

@end
