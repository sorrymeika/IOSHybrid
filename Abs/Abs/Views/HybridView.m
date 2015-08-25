//
//  JavaScriptAlert.m
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//
#import "HybridView.h"

@interface HybridView ()
@end

@implementation HybridView

@synthesize hybridDelegate;

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

@end