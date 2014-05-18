
//
//  CDVCardImageRecognizerPreviewLayer.m
//  cardvision
//
//  Created by Nils Fischer on 17.12.13.
//  Copyright (c) 2013 Nils Fischer. All rights reserved.
//

#import "CDVCardImageRecognizerPreviewLayer.h"

@implementation CDVCardImageRecognizerPreviewLayer

- (void)drawInContext:(CGContextRef)context {
    [super drawInContext:context];
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);

    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextSetLineWidth(context, 3.);

    CGContextFillRect(context, CGRectMake(center.x-15, center.y-15, 30, 30));
    
}

@end
