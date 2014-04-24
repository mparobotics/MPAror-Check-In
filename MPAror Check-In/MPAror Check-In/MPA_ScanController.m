//
//  igViewController.m
//  ScanBarCodes
//
//  Created by Torrey Betts on 10/10/13.
//  Copyright (c) 2013 Infragistics. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MPA_ScanController.h"
#import "MPA_CheckInController.h"
#import "MPA_ViewHoursController.h"

@interface MPA_ScanController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    BOOL scanActive;
    
    UIView *_highlightView;
    UILabel *_label;
}
@end

@implementation MPA_ScanController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scanActive = YES;
    
    NSLog(@"%d", _mode);
    
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    [_cameraView addSubview:_highlightView];
    
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, _cameraView.bounds.size.height - 40, _cameraView.bounds.size.width, 40);
    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    _label.textColor = [UIColor whiteColor];
    
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"Please Scan Badge";
    [_cameraView addSubview:_label];
    
    _session = [[AVCaptureSession alloc] init];
    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionFront) {
                _device = device;
            }
        }
    }
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = _cameraView.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_cameraView.layer addSublayer:_prevLayer];
    
    [_session startRunning];
    
    [_cameraView bringSubviewToFront:_highlightView];
    [_cameraView bringSubviewToFront:_label];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            if (scanActive) {
                _label.text = detectionString;
                [self validateLogin:detectionString];
                detectionString = nil;
                scanActive = NO;
            }
            break;
        }
        else
            _label.text = @"Please Scan Badge";
    }
    
    _highlightView.frame = highlightViewRect;
}

-(void)validateLogin:(NSString *)name {
    NSArray *personArray = [name componentsSeparatedByString:@":"];
    if ([[personArray objectAtIndex:0] isEqualToString:@"3926"]) {
        _outgoingperson = [personArray objectAtIndex:1];
        NSLog(_outgoingperson);
        NSString *segueMode;
        if (_mode == 0) {
            segueMode = @"checkin";
        } else if (_mode == 1) {
            segueMode = @"viewhours";
        }
        [self performSegueWithIdentifier:segueMode sender:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"The badge you scanned was not in our database. Please try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alertView show];
        NSLog(@"No Person Found");
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scanOn) userInfo:nil repeats:NO];
    }
}

-(void)scanOn {
    NSLog(@"Scan Active");
    scanActive = YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"checkin"]){
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        MPA_CheckInController *controller = (MPA_CheckInController *)navController.topViewController;
        controller.incomingperson = _outgoingperson;
    }
    if([segue.identifier isEqualToString:@"viewhours"]){
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        MPA_ViewHoursController *controller = (MPA_ViewHoursController *)navController.topViewController;
        controller.incomingperson = _outgoingperson;
    }
}

@end