//
//  JavaScriptAlert.m
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//
#import "BrowserPlugin.h"
#import "CPModalWebViewController.h"

@interface BrowserPlugin (){
    
}
@end

@implementation BrowserPlugin


-(void)execute:(NSDictionary *)command{
    NSString * url=[command objectForKey:@"params"];
    
    CPModalWebViewController *webC = [[CPModalWebViewController alloc] initWithAddress:url];
    
    [_hybridView.viewController presentViewController:webC animated:YES completion:^{}];
}


@end