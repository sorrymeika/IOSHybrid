//
//  JavaScriptAlert.m
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//
#import "MotionPlugin.h"

@interface MotionPlugin (){
    
}
@end

@implementation MotionPlugin


-(void)execute:(NSDictionary *)command{
    NSString * action=[command objectForKey:@"action"];
    
    if ([action isEqualToString:@"stop"]) {
        [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];
        
    } else {
        //摇一摇
        [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
        [_hybridView.viewController becomeFirstResponder];
    }
}


@end