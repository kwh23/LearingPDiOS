//
//  AppDelegate.h
//  MyPDProject
//
//  Created by Kieran Warner-Hunt on 28/07/2015.
//  Copyright (c) 2015 Kieran Warner-Hunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdAudioController.h"
#import "PdBase.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, PdReceiverDelegate> {
    int rCount;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PdAudioController *pd;


@end

