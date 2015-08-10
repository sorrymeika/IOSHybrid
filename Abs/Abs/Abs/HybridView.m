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
    /*
    UIAlertView* dialogue = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"tt" otherButtonTitles:nil, nil];
    [dialogue show];
    [dialogue autorelease];
     */
    
    [self.hybridDelegate hybridCall:self data:message];
}

@end