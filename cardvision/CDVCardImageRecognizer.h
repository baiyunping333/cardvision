//
//  CDVCardImageRecognizingManager.h
//  cardvision
//
//  Created by Nils Fischer on 16.12.13.
//  Copyright (c) 2013 Nils Fischer. All rights reserved.
//

#import "VIManager.h"
#import "VIPlayingCard.h"
#import "CDVCardImageRecognizerPreviewLayer.h"

@protocol CDVCardImageRecognizerDelegate;

@interface CDVCardImageRecognizer : VIManager <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak, nonatomic) id <CDVCardImageRecognizerDelegate> delegate;

@property (strong, nonatomic) CDVCardImageRecognizerPreviewLayer *previewLayer;

@end

@protocol CDVCardImageRecognizerDelegate

@end