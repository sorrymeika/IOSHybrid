//
//  JavaScriptAlert.m
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//
#import "HybridAction.h"
#import "ViewUtil.h"

@interface HybridAction (){
    NSDictionary *_command;
    NSString *_callbackJsFn;
}
@end

@implementation HybridAction

@synthesize delegate;

-(instancetype)initWithHybridView:(UIHybridView *)hybridView{
    _hybridView=hybridView;
    
    return self;
}

-(void)execute:(NSDictionary *)command{
    _command=command;
    _callbackJsFn=[command objectForKey:@"callback"];
}
@end
