//
//  ViewController.h
//  MyPDProject
//
//  Created by Kieran Warner-Hunt on 28/07/2015.
//  Copyright (c) 2015 Kieran Warner-Hunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDPatch.h"

@interface ViewController : UIViewController {
    BOOL isPlaying;
    int whichPatchIsPlaying;
    BOOL isFinished;
    int nextPatchToPlay;
}

@property (strong, nonatomic) PDPatch *patch1;
@property (strong, nonatomic) PDPatch *patch2;
- (IBAction)resetPlayCont:(UIButton *)sender;

- (void)handlePlaybackPercentage:(NSNotification*)n;
- (void)file2PlayEnd:(NSNotification*)n;

- (void)togglePlayback;
- (void)startPlaybackAfterPreviousFinish;

@end

