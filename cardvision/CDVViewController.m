//
//  CDVViewController.m
//  cardvision
//
//  Created by Nils Fischer on 16.12.13.
//  Copyright (c) 2013 Nils Fischer. All rights reserved.
//

#import "CDVViewController.h"
#import "VICaptureSessionManager.h"
#import "CDVCardImageRecognizer.h"

@interface CDVViewController () <CDVCardImageRecognizerDelegate>

@property (strong, nonatomic) VICaptureSessionManager *captureSessionManager;
@property (strong, nonatomic) CDVCardImageRecognizer *cardImageRecognizer;

@end

@implementation CDVViewController

- (void)viewDidLoad {
    
    self.cardImageRecognizer = [CDVCardImageRecognizer defaultManager];
    self.cardImageRecognizer.delegate = self;
    
    self.captureSessionManager = [VICaptureSessionManager defaultManager];
    self.captureSessionManager.captureSession.sessionPreset = AVCaptureSessionPresetMedium; // TODO: consider
    
    [self.captureSessionManager setInputMediaType:AVMediaTypeVideo];
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [self.captureSessionManager setOutput:videoDataOutput];
    
    [videoDataOutput setSampleBufferDelegate:self.cardImageRecognizer queue:dispatch_queue_create("videoDataQueue", NULL)];
    videoDataOutput.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) }; // TODO: consider
    
    CDVCardImageRecognizerPreviewLayer *previewLayer = [[CDVCardImageRecognizerPreviewLayer alloc] initWithSession:self.captureSessionManager.captureSession];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.view.layer.bounds;
    [self.view.layer addSublayer:previewLayer];

    self.captureSessionManager.previewLayer = previewLayer;
    CDVCardImageRecognizerPreviewLayer *overlayLayer = [[CDVCardImageRecognizerPreviewLayer alloc] init];
    overlayLayer.frame = self.view.layer.bounds;
    [self.view.layer addSublayer:overlayLayer];
    self.cardImageRecognizer.previewLayer = overlayLayer;

    [self.captureSessionManager.captureSession startRunning];
}

#pragma mark - Card Recognizer Delegate



@end
