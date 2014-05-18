//
//  CDVCardImageRecognizingManager.m
//  cardvision
//
//  Created by Nils Fischer on 16.12.13.
//  Copyright (c) 2013 Nils Fischer. All rights reserved.
//

@import AVFoundation;

#import "CDVCardImageRecognizer.h"

typedef struct CDVPixelColor {
    unsigned char red;
    unsigned char green;
    unsigned char blue;
    unsigned char alpha;
} CDVPixelColor;

@interface CDVCardImageRecognizer ()

- (void)processPixelData:(CDVPixelColor *)pixelData width:(size_t)width height:(size_t)height;

@end

@implementation CDVCardImageRecognizer

- (void)processPixelData:(CDVPixelColor *)pixelData width:(size_t)width height:(size_t)height
{
    int x = width/2;
    int y = height/2;
    CDVPixelColor pixel = pixelData[width*y+x];
    UIColor *color = [UIColor colorWithRed:pixel.red/255. green:pixel.green/255. blue:pixel.blue/255. alpha:pixel.alpha/255.];
    
    self.previewLayer.color = color;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.previewLayer setNeedsDisplay];
    }];

}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
    // This example assumes the sample buffer came from an AVCaptureOutput,
    // so its image buffer is known to be a pixel buffer.
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer.
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    // Get the number of bytes per row for the pixel buffer.
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height.
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space.
    static CGColorSpaceRef colorSpace = NULL;
    if (colorSpace == NULL) {
        colorSpace = CGColorSpaceCreateDeviceRGB();
        if (colorSpace == NULL) {
            // Handle the error appropriately.
            return;
        }
    }
    
    // Get the base address of the pixel buffer.
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    
    // Create a Quartz direct-access data provider that uses data we supply.
    CGDataProviderRef dataProvider =
    CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    // Create a bitmap image from data supplied by the data provider.
    CGImageRef cgImage =
    CGImageCreate(width, height, 8, 32, bytesPerRow,
                  colorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
                  dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    // Write pixel data to memory
    unsigned char *rawPixelData = (unsigned char*) calloc(height * bytesPerRow, sizeof(unsigned char));
    CGContextRef context = CGBitmapContextCreate(rawPixelData, width, height, 8, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    CGImageRelease(cgImage);
    CGContextRelease(context);
    
    CDVPixelColor *pixelData = (CDVPixelColor *)rawPixelData;

    [self processPixelData:pixelData width:width height:height];
    
    free(rawPixelData);
    
}

@end
