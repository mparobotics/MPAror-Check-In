//
//  MPA_CheckInController.m
//  MPAror Check-In
//
//  Created by Brendan Boyle on 1/19/14.
//  Copyright (c) 2014 MPAror Robotics. All rights reserved.
//

#import "MPA_CheckInController.h"

@interface MPA_CheckInController ()

@end

@implementation MPA_CheckInController

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
    NSString *urlString = @"https://docs.google.com/forms/d/1nBtoYjZY80qq3Ol2hRPGkvO_I_cdQS6CSdYRMl97xAk/viewform";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [_formView loadRequest:request];
    _formView.delegate = self;
    //[_formView stringByEvaluatingJavaScriptFromString: @"alert('Hi');"];
    
    _name.text = [NSString stringWithFormat:@"Hello %@!", _incomingperson];
    _outgoingName = _incomingperson;
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
    NSLog(@"%@",dateString);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *weekdayComponents =[calendar components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    
    NSInteger weekday = [weekdayComponents weekday];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    float hour = [components hour];
    float minutes = [components minute];
    
    hour = hour+(minutes/60);
    
    if (weekday < 7) {
        //Weekday Hours
        if (hour > 17.5) {
            _outgoingSection = @"2";
        } else {
            _outgoingSection = @"1";
        }
    } else {
        //Saterday Hours
        if (hour >= 9 && hour < 11) {
            _outgoingSection = @"1";
        } else if (hour >= 11 && hour < 13) {
            _outgoingSection = @"2";
        } else if (hour >= 13 && hour < 15) {
            _outgoingSection = @"3";
        } else if (hour >= 15 && hour < 17) {
            _outgoingSection = @"4";
        } else if (hour >= 17 && hour < 19) {
            _outgoingSection = @"5";
        }
    }
    
    NSString *dateOutput = [NSString stringWithFormat:@"Section %@. %@", _outgoingSection, dateString];
    _time.text = dateOutput;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Substitute your Objective-C values into the string
    NSString *javaScript = [NSString stringWithFormat:@"document.getElementById('entry_775145236').value = '%@'; document.getElementById('entry_1716316065').value = '%@'", _outgoingName, _outgoingSection];
    // Make the UIWebView method call
    NSString *response = [_formView stringByEvaluatingJavaScriptFromString:javaScript];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
