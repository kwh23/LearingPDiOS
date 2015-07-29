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
    void *patch;
    self = [super init];
    if (self) {
        patch = [PdBase openFile:pdFile path:[[NSBundle mainBundle]resourcePath]];
        if (!patch) {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Uh-oh" message:@"Pd patch not found" delegate:self cancelButtonTitle:@"Crap" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    return self;
}

@end
 