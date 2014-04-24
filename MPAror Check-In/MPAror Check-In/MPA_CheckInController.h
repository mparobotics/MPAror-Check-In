//
//  MPA_CheckInController.h
//  MPAror Check-In
//
//  Created by Brendan Boyle on 1/19/14.
//  Copyright (c) 2014 MPAror Robotics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPA_CheckInController : UIViewController

@property(nonatomic) NSString *incomingperson;
@property(nonatomic) NSString *outgoingName;
@property(nonatomic) NSString *outgoingSection;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIWebView *formView;

@end
