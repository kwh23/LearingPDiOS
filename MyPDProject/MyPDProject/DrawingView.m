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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePlaybackPercentage:) name:@"PlaybackPercentage" object:nil];
    rCount = 0;
    //Initialise the directions to go to the right, and down (touch pos starts in top left corner)
    hozDir = 1;
    vertDir = 1;
    return self;
}

- (void)handlePlaybackPercentage:(NSNotification *)n {
    NSDictionary* dict = [n userInfo];
    playbackPercentage = [[dict objectForKey:@"PlaybackPercentage"] floatValue];
    rCount++;
//    NSLog(@"Playback percentage called with val: %0.02f, recieved %i counts", playbackPercentage, rCount);
    [self setNeedsDisplay];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    shouldClearBackground = YES;
    float width = rect.size.width;
    float height = rect.size.height;
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
//        return;
    }
    //Start a new image
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Draw our existing image
    [storedImage drawInRect:rect];
    //Draw new stuff on top
    for(int i = 0; i < 5; ++i) {
        int randOffsetX = arc4random_uniform(50) - 25;
        int randOffsetY = arc4random_uniform(50) - 25;
        int randWidth = arc4random_uniform(10) - 5;
        int randHeight = arc4random_uniform(10) - 5;
        int randAlpha = arc4random_uniform(255);
        float newAlpha = (float)randAlpha / 255.f;
        float newX = lastTouchPos.x + randOffsetX;
        float newY = lastTouchPos.y + randOffsetY;
//        newX = (int)newX % (int)width;
//        if(newX < 0) {
//            newX = width + newX;
//        }
//        newY = (int)newY % (int)height;
//        if(newY < 0) {
//            newY = height + newY;
//        }
        CGRect littleSquare = CGRectMake(newX, newY, 20.f + randWidth, 20.f + randHeight);
        
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
    
    //Update the next touchPosition to draw
    float curXPerc = lastTouchPos.x / width;
    float curYPerc = lastTouchPos.y / height;
    int xRand = arc4random_uniform(100);
    int yRand = arc4random_uniform(100);
    //The below method converges around 50, I'll do a truly random one and let it wrap around the screen
//    hozDir = xRand > (int)(curXPerc * 100.f) ? 1 : -1;
//    vertDir = yRand > (int)(curYPerc * 100.f) ? 1 : -1;
    hozDir = xRand > (int)(50) ? 1 : -1;
    vertDir = yRand > (int)(50) ? 1 : -1;
    int randDistHoz = arc4random_uniform(10);
    int randDistVert = arc4random_uniform(10);
    float hozMove = randDistHoz * hozDir;
    float vertMove = randDistVert * vertDir;
    lastTouchPos.x += hozMove;
    lastTouchPos.y += vertMove;
    if(lastTouchPos.x < 0) {
        lastTouchPos.x = width - hozMove;
    }
    if(lastTouchPos.x > width) {
        lastTouchPos.x = hozMove;
    }
    if(lastTouchPos.y < 0) {
        lastTouchPos.y = height - vertMove;
    }
    if(lastTouchPos.y > height) {
        lastTouchPos.y = vertMove;
    }
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
//    lastTouchPos = [[touches anyObject] locationInView:self];
//    NSLog(@"Touch received at point x/y: %0.02f/%0.02f", lastTouchPos.x, lastTouchPos.y);
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    lastTouchPos = [[touches anyObject] locationInView:self];
    [self setNeedsDisplay];
}

@end
