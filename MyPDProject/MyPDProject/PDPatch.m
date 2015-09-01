//
//  PDPatch.m
//  MyPDProject
//
//  Created by Kieran Warner-Hunt on 28/07/2015.
//  Copyright (c) 2015 Kieran Warner-Hunt. All rights reserved.
//

#import "PDPatch.h"


@implementation PDPatch

-(void)onOff:(BOOL)yesNo{
    float yn = (float)yesNo;
    [PdBase sendFloat:yn toReceiver:@"onOff"];
}

-(instancetype)initWithFile:(NSString *)pdFile{
    self = [super init];
    if (self) {
        patch = [PdBase openFile:pdFile path:[[NSBundle mainBundle]resourcePath]];
        if (!patch) {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Uh-oh" message:@"Pd patch not found" delegate:self cancelButtonTitle:@"Crap" otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            NSLog(@"Banging the pd file to load the correct Fibonnacci number");
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSNumber* fibNum = [defaults objectForKey:@"fib_play_count"];
            if(fibNum) {
                int fibCount = [fibNum floatValue];
                NSLog(@"Got a count of %i, will send", fibCount);
                [PdBase sendFloat:(float)fibCount toReceiver:@"fibCountFromXcode"];
            }
            else {
                NSLog(@"No item for fib_play_count found in user defaults");
            }
        }
    }
    return self;
}

- (void*)getPatch {
    return patch;
}

@end
 