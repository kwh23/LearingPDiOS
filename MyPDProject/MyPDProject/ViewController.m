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

- (IBAction)onSwitchCange:(id)sender {
    [self.patch onOff:[sender isOn]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.patch = [[PDPatch alloc]initWithFile:@"filePlay.pd"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetPlayCont:(UIButton *)sender {
    NSLog(@"Resetting the play cont, will be 0 on next load");
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSNumber* fibNum = [NSNumber numberWithFloat:0.f];
    [defaults setObject:fibNum forKey:@"fib_play_count"];
    [defaults synchronize];
}
@end
