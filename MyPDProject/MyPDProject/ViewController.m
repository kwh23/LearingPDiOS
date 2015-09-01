//
//  ViewController.m
//  MyPDProject
//
//  Created by Kieran Warner-Hunt on 28/07/2015.
//  Copyright (c) 2015 Kieran Warner-Hunt. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *onOff;

@end

@implementation ViewController

- (IBAction)stopStartPress:(UIButton *)sender {
    [self togglePlayback];
}

- (IBAction)onSwitchCange:(id)sender {
    BOOL state = [sender isOn];
    if(state) {
        isPlaying = YES;
        if(nextPatchToPlay == 0) {
            whichPatchIsPlaying = 0;
            [self.patch1 onOff:YES];
        }
        else if(nextPatchToPlay == 1) {
            whichPatchIsPlaying = 1;
            [self.patch2 onOff:YES];
        }
    }
    else {
        isPlaying = NO;
        if(whichPatchIsPlaying == 0) {
            [self.patch1 onOff:NO];
        }
        else if(whichPatchIsPlaying == 1) {
            [self.patch2 onOff:NO];
        }
    }
}

- (void)togglePlayback {
    if(isPlaying) {
        isPlaying = NO;
        if(whichPatchIsPlaying == 0) {
            [self.patch1 onOff:NO];
        }
        else if(whichPatchIsPlaying == 1) {
            [self.patch2 onOff:NO];
        }
    }
    else {
        isPlaying = YES;
        isFinished = NO;
        if(whichPatchIsPlaying == 0) {
            [self.patch1 onOff:YES];
            nextPatchToPlay = 1;
        }
        else if(whichPatchIsPlaying == 1) {
            [self.patch2 onOff:YES];
            nextPatchToPlay = 0;
        }
    }
}

- (void)startPlaybackAfterPreviousFinish {
    if(whichPatchIsPlaying == 0) {
        [PdBase closeFile:[self.patch1 getPatch]];
        self.patch1 = nil;
    }
    else if(whichPatchIsPlaying == 1) {
        [PdBase closeFile:[self.patch2 getPatch]];
        self.patch2 = nil;
    }
    if(nextPatchToPlay == 0) {
        self.patch1 = [[PDPatch alloc]initWithFile:@"filePlay.pd"];
        [self.patch1 onOff:YES];
        whichPatchIsPlaying = 0;
    }
    else if(nextPatchToPlay == 1) {
        self.patch2 = [[PDPatch alloc]initWithFile:@"filePlay2.pd"];
        [self.patch2 onOff:YES];
        whichPatchIsPlaying = 1;
    }
    isPlaying = YES;
    isFinished = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stopStartButton.imageView.clipsToBounds = NO;
    self.stopStartButton.imageView.contentMode = UIViewContentModeCenter;
    
    whichPatchIsPlaying = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePlaybackPercentage:) name:@"PlaybackPercentage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(file2PlayEnd:) name:@"File2PlayEnd" object:nil];
    // Do any additional setup after loading the view, typically from a nib.
    self.patch1 = [[PDPatch alloc]initWithFile:@"filePlay.pd"];
//    self.patch2 = [[PDPatch alloc]initWithFile:@"filePlay2.pd"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handlePlaybackPercentage:(NSNotification *)n {
    NSDictionary* dict = [n userInfo];
    float playbackPercentage = [[dict objectForKey:@"PlaybackPercentage"] floatValue];
    //    NSLog(@"Playback percentage called with val: %0.02f, recieved %i counts", playbackPercentage, rCount);
    float buttonRotation = (playbackPercentage * M_2_PI * 64.f);
    self.stopStartButton.imageView.transform = CGAffineTransformMakeRotation(buttonRotation);
    if(playbackPercentage >= 1.f && !isFinished) {
        isFinished = YES;
        isPlaying = NO;
        //Do other stuff, like line up the next track
        nextPatchToPlay = (whichPatchIsPlaying + 1) % 2;
        [self startPlaybackAfterPreviousFinish];
    }
}

- (void)file2PlayEnd:(NSNotification *)n {
    if(!isFinished) {
        isFinished = YES;
        isPlaying = NO;
        nextPatchToPlay = 0;
        [self startPlaybackAfterPreviousFinish];
    }
}

- (IBAction)resetPlayCont:(UIButton *)sender {
    NSLog(@"Resetting the play cont, will be 0 on next load");
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSNumber* fibNum = [NSNumber numberWithFloat:0.f];
    [defaults setObject:fibNum forKey:@"fib_play_count"];
    [defaults synchronize];
}
@end
