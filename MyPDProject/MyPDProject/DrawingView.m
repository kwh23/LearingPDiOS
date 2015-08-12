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

//- (id)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    NSLog(@"Init with frame");
//    return self;
//}

//- (BOOL)isOpaque {
//    return YES;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if(shouldClearBackground) {
        [[UIColor whiteColor] set];
        UIRectFill(rect);
        shouldClearBackground = NO;
        return;
    }
    
//    if(lastTouchPos.x ) {
    for(int i = 0; i < 1; ++i) {
        int randOffset = arc4random_uniform(50);
        int randWidth = arc4random_uniform(10);
        int randHeight = arc4random_uniform(10);
        int randAlpha = arc4random_uniform(255);
//        NSLog(@"Random value: %i", randAlpha);
        float newAlpha = (float)randAlpha / 255.f;
//        NSLog(@"Alpha val = %0.02f", newAlpha);
        CGRect littleSquare = CGRectMake(lastTouchPos.x + randOffset, lastTouchPos.y + randOffset, 20.f + randWidth, 20.f + randHeight);
        [[UIColor colorWithWhite:0.f alpha:newAlpha] set];
        UIRectFrameUsingBlendMode(littleSquare, kCGBlendModeSourceAtop);
    }
//    }
    
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    lastTouchPos = [[touches anyObject] locationInView:self];
    NSLog(@"Touch received at point x/y: %0.02f/%0.02f", lastTouchPos.x, lastTouchPos.y);
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    lastTouchPos = [[touches anyObject] locationInView:self];
    [self setNeedsDisplay];
}

@end
