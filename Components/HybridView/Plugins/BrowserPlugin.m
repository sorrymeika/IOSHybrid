//
//  JavaScriptAlert.m
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//
#import "BrowserPlugin.h"
#import "ModalWebViewController.h"

@interface BrowserPlugin (){
    
}
@end

@implementation BrowserPlugin


-(void)execute:(NSDictionary *)command{
    NSDictionary *params = [command objectForKey:@"params"];
    
    NSString * url = [params objectForKey:@"url"];
    NSString * title = [params objectForKey:@"title"];
    
    ModalWebViewController *webC = [[ModalWebViewController alloc] initWithAddress:url];
    
    [_hybridView.viewController presentViewController:webC animated:YES completion:^{}];
}


@end
