//
//  JavaScriptAlert.m
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//
#import "CMBPayPlugin.h"
#import "CMBModalWebViewController.h"

@interface CMBPayPlugin (){
    
}
@end

@implementation CMBPayPlugin


-(void)execute:(NSDictionary *)command{
    NSString * url=[command objectForKey:@"params"];
    
    NSLog(@"url:%@", url);
    
    CMBModalWebViewController *cmbpay = [[CMBModalWebViewController alloc] initWithAddress:url];
    
    
    [_hybridView.viewController presentViewController:cmbpay animated:YES completion:^{}];
}


@end