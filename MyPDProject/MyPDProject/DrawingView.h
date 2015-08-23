//
//  DrawingView.h
//  MyPDProject
//
//  Created by Mark Havryliv on 12/08/2015.
//  Copyright (c) 2015 Kieran Warner-Hunt. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ARC4RANDOM_MAX      0x100000000

@interface DrawingView : UIView {
    CGPoint lastTouchPos;
    BOOL shouldClearBackground;
    UIImage* storedImage;
}

//Simple helper function to store the rotation code
- (void)rotateAndDrawRetangle:(CGRect)rect WithAngle:(float)radians CGContext:(CGContextRef)context;

@end
