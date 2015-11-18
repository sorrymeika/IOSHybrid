//
//  JavaScriptAlert.m
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//
#import "UIHybridView.h"
#import "ViewUtil.h"
#import "StringUtil.h"

@interface UIHybridView ()
@end

@implementation UIHybridView

@synthesize hybridDelegate;
@synthesize viewController;

-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame{
    
    NSString *prefix=@"slapp://";
    if ([message hasPrefix:prefix])
    {
        message=[message substringFromIndex:prefix.length];
        
        NSError *error = nil;
        NSDictionary *command = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        
        [self.hybridDelegate callNativeApi:self command:command];
    }
    else
    {
        UIAlertView* dialogue = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [dialogue show];
        //[dialogue autorelease];
    }
}

-(void)loadRequestWidthAddress:(NSString *)url
{
    [ViewUtil loadDocument:self url:url];
}

-(void)callback:(NSString *)callback params:(NSDictionary*) params{
    [self stringByEvaluatingJavaScriptFromString:[@"window.hybridFunctions." stringByAppendingFormat:@"%@(%@);",callback,[StringUtil stringify:params]]];
}

@end