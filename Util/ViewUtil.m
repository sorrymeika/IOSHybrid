//
//  NSObject+ViewUtil.m
//  Letsgo
//
//  Created by 孙路 on 15/8/13.
//  Copyright (c) 2015年 Miku. All rights reserved.
//

#import "ViewUtil.h"

@implementation ViewUtil : NSObject

+ (void) alert:(NSString*)message cancelButtonTitle:(NSString*) title{
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:title otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

+ (void) alert:(NSString*)message{
    [ViewUtil alert:message cancelButtonTitle:@"关闭"];
}

+ (void)loadDocument:(UIWebView *)webView url:(NSString *)url{
    NSURLRequest *request;
    if ([url hasPrefix:@"http://"]){
        NSLog(@"%@",url);
        
        request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
    } else {
        NSString *mainBundleDirectory=[[NSBundle mainBundle] bundlePath];
        NSString *path=[mainBundleDirectory stringByAppendingPathComponent:url];
        NSURL *url=[NSURL fileURLWithPath:path];
        
        
        request=[NSURLRequest requestWithURL:url];
    }
    webView.scalesPageToFit=YES;
    
    [webView loadRequest:request];
}

@end
