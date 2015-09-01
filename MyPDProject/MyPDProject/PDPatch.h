//
//  PDPatch.h
//  MyPDProject
//
//  Created by Kieran Warner-Hunt on 28/07/2015.
//  Copyright (c) 2015 Kieran Warner-Hunt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import  "PdDispatcher.h"


@interface PDPatch : NSObject {
    void *patch;
}

-(void)onOff:(BOOL)yesNo;
-(instancetype)initWithFile:(NSString *)pdFile;

- (void*)getPatch;

@end
