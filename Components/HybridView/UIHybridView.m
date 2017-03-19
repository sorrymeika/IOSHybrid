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
#import <WebKit/WebKit.h>

@interface _UIWebView: UIWebView {
}
@end

@implementation _UIWebView {
    
    UIHybridView *parentHybridView;
}

-(_UIWebView *)initWithHybridView:(UIHybridView *)hybridView frame:(CGRect) frame {
    parentHybridView = hybridView;
    
    self = [self initWithFrame:frame];
    
    self.allowsInlineMediaPlayback = true;
    
    return self;
}

-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame{
    
    NSString *prefix=@"slapp://";
    if ([message hasPrefix:prefix])
    {
        message=[message substringFromIndex:prefix.length];
        
        NSError *error = nil;
        NSDictionary *command = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        
        [parentHybridView.hybridDelegate callNativeApi:parentHybridView command:command];
    }
    else
    {
        UIAlertView* dialogue = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [dialogue show];
        //[dialogue autorelease];
    }
}
@end


@interface _WKWebView: WKWebView<WKUIDelegate> {
}
@end

@implementation _WKWebView {
    
    UIHybridView *parentHybridView;
}

-(_WKWebView *)initWithHybridView:(UIHybridView *)hybridView frame:(CGRect) frame {
    parentHybridView = hybridView;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    config.allowsInlineMediaPlayback=true;
    config.requiresUserActionForMediaPlayback=NO;
    
    return [self initWithFrame:frame configuration:config];
}

-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    
    NSLog(@"alert(%@)",message);
    
    
    NSString *prefix=@"slapp://";
    if ([message hasPrefix:prefix])
    {
        
        completionHandler();
        
        message=[message substringFromIndex:prefix.length];
        
        NSError *error = nil;
        NSDictionary *command = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        
        [parentHybridView.hybridDelegate callNativeApi:parentHybridView command:command];
    }
    else
    {
        UIAlertView* dialogue = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [dialogue show];
        //[dialogue autorelease];
        
        completionHandler();
    }
}
@end



@interface UIHybridView () {
}
@end


@implementation UIHybridView {
    
    _UIWebView *uiWebView;
    _WKWebView *wkWebView;
}

@synthesize hybridDelegate;
@synthesize viewController;
@synthesize webView;
@synthesize WEBVIEW_TYPE;


-(UIHybridView *)initWithFrame:(CGRect)frame
{
    
    Class wkWebViewClass = NSClassFromString(@"WKWebView");
    UIScrollView *scrollView;
    
    // wkWebViewClass=NULL;
    
    if(wkWebViewClass) {
        
        NSLog(@"%@",@"wkWebView");
        
        self.WEBVIEW_TYPE = @"WKWebView";
        
        self.webView = wkWebView = [[_WKWebView alloc] initWithHybridView:self frame:frame];
        
        scrollView =wkWebView.scrollView;
        
        scrollView.scrollEnabled=NO;
        
        wkWebView.UIDelegate = wkWebView;
        
        [wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            NSLog(@"%@", result);
        }];
        
    } else {
        
        NSLog(@"%@",@"uiWebView");
        
        self.WEBVIEW_TYPE = @"UIWebView";
        
        self.webView = uiWebView = [[_UIWebView alloc] initWithHybridView:self frame:frame];
        
        
        uiWebView.scalesPageToFit = YES;
        scrollView =uiWebView.scrollView;
        
    }
    
    
    [scrollView setBounces:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    
    scrollView.delegate=self;
    
    [webView setBackgroundColor:[UIColor whiteColor]];
    
    return self;
}

-(void)loadUrl:(NSString *)url
{
    NSURL *uri;
    
    NSLog(@"%@",url);

    
    if ([url hasPrefix:@"http://"]){
        
        uri = [NSURL URLWithString:url];
        
    } else {
        
        NSString *mainBundleDirectory=[[NSBundle mainBundle] bundlePath];
        NSString *path=[mainBundleDirectory stringByAppendingPathComponent:url];
        
        NSLog(@"%@",path);
        
        uri = [NSURL fileURLWithPath:path];
        
    }
    
    NSURLRequest *request=[NSURLRequest requestWithURL:uri];
    
    if (wkWebView) {
        [wkWebView loadRequest:request];
        
    } else {
        
        [uiWebView loadRequest:request];
    }
    
    
}

-(void)callback:(NSString *)callback params:(NSDictionary*) params{
    
    NSString *data = [StringUtil stringify:params];
    [self callbackWithString:callback params:data];
}


-(void)callbackWithString:(NSString *)callback params:(NSString*) params{
    
    NSString *js = [@"window.hybridFunctions." stringByAppendingFormat:@"%@(%@);",callback,params];
    
    NSLog(@"eval:%@", js);
    
    [self evaluateJavaScript:js];
}

-(void)evaluateJavaScript:(NSString *)js {
    
    if (wkWebView) {
        [wkWebView evaluateJavaScript:js completionHandler:^(id obj, NSError *error) {
            
        }];
        
    } else {
        
        [uiWebView stringByEvaluatingJavaScriptFromString:js];
    }
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView{
    return nil;
}


@end


