//
//  DrawingView.m
//  MyPDProject
//
//  Created by Mark Havryliv on 12/08/2015.
//  Copyright (c) 2015 Kieran Warner-Hunt. All rights reserved.
//

#import "DrawingView.h"

@implementation DrawingView


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    NSLog(@"init with coder" );
    shouldClearBackground = YES;
    return self;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    shouldClearBackground = YES;
    //    if(shouldClearBackground) {
    //        [[UIColor whiteColor] set];
    //        UIRectFill(rect);
    //        shouldClearBackground = NO;
    //        NSLog(@"Clearing background");
    //        return;
    //    }
    
    if(!storedImage) {
        UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.height));
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        // drawing code here (using context)
        //        UIColor * whiteColor = [UIColor colorWithWhite:0.5f alpha:1.f];
        UIColor *blackColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:1.f];
        
        CGContextSetFillColorWithColor(context, blackColor.CGColor);
        CGContextFillRect(context, rect);
        
        storedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    if(lastTouchPos.x == 0 && lastTouchPos.y == 0) {
        [storedImage drawInRect:rect];
        return;
    }
    //Start a new image
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Draw our existing image
    [storedImage drawInRect:rect];
    //Draw new stuff on top
    for(int i = 0; i < 10; ++i) {
        int randOffsetX = arc4random_uniform(50) - 25;
        int randOffsetY = arc4random_uniform(50) - 25;
        int randWidth = arc4random_uniform(10) - 5;
        int randHeight = arc4random_uniform(10) - 5;
        int randAlpha = arc4random_uniform(255);
        float newAlpha = (float)randAlpha / 255.f;
        CGRect littleSquare = CGRectMake(lastTouchPos.x + randOffsetX, lastTouchPos.y + randOffsetY, 20.f + randWidth, 20.f + randHeight);
        
        UIColor *rectColor = [UIColor colorWithWhite:1.f alpha:newAlpha];
        CGContextSetStrokeColorWithColor(context, rectColor.CGColor);
        //Rotate and draw the rect
        float radians = (float)((float)arc4random()/ARC4RANDOM_MAX) * M_2_PI - M_1_PI;
        [self rotateAndDrawRetangle:littleSquare WithAngle:radians CGContext:context];
        
//        CGContextStrokeRect(context, littleSquare);
    }
    
    storedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [storedImage drawInRect:rect];

}

- (void)rotateAndDrawRetangle:(CGRect)rect WithAngle:(float)radians CGContext:(CGContextRef)context {
    CGContextSaveGState(context);
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    
    CGFloat halfWidth = width / 2.0;
    CGFloat halfHeight = height / 2.0;
    CGPoint center = CGPointMake(x + halfWidth, y + halfHeight);
    
    // Move to the center of the rectangle:
    CGContextTranslateCTM(context, center.x, center.y);
    // Rotate:
    CGContextRotateCTM(context, radians);
    // Draw the rectangle centered about the center:
    CGRect rotatedRect = CGRectMake(-halfWidth, -halfHeight, width, height);
    CGContextAddRect(context, rotatedRect);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    lastTouchPos = [[touches anyObject] locationInView:self];
//    NSLog(@"Touch received at point x/y: %0.02f/%0.02f", lastTouchPos.x, lastTouchPos.y);
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    lastTouchPos = [[touches anyObject] locationInView:self];
    [self setNeedsDisplay];
}

@end
