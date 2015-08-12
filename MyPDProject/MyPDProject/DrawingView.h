//
//  DrawingView.h
//  MyPDProject
//
//  Created by Mark Havryliv on 12/08/2015.
//  Copyright (c) 2015 Kieran Warner-Hunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingView : UIView {
    CGPoint lastTouchPos;
    BOOL shouldClearBackground;
}

@end
