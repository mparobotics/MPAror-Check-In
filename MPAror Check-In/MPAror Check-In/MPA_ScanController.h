//
//  MPA_ScanController.h
//  MPAror Check-In
//
//  Created by Brendan Boyle on 1/19/14.
//  Copyright (c) 2014 MPAror Robotics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPA_ScanController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *cameraView;

@property(nonatomic) NSInteger mode;
@property(nonatomic) NSString *outgoingperson;

-(void)validateLogin:(NSString *)name;
-(void)scanOn;

@end
