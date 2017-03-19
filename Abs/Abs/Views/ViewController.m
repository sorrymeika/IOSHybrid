//
//  ViewController.m
//  Abs
//
//  Created by Miku on 13-10-7.
//  Copyright (c) 2013年 Miku. All rights reserved.
//

#import "ViewController.h"
#import "UIHybridView.h"
#import "ViewUtil.h"
#import "HttpUtil.h"
#import "CPModalWebViewController.h"
#import "BrowserPlugin.h"
#import "WXPlugin.h"
#import "LocationPlugin.h"
#import "ImagePlugin.h"
#import "QQPlugin.h"
#import "AliPlugin.h"
#import "HybridAction.h"
#import "SystemPlugin.h"
#import "CMBPayPlugin.h"
#import "AssetsPlugin.h"

@interface ViewController (){
    NSDictionary *plugins;
}
@end

@implementation ViewController

//- (void) loadView

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


- (void) webViewDidFinishLoad: (UIWebView *) webView
{
    // trigger an alert.  for demonstration only:
    
}

- (BOOL)canBecomeFirstResponder
{
    return YES;// default is NO
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化webview
    hybridView = [[UIHybridView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIView *webView = hybridView.webView;
    [self.view addSubview: webView];
   
    hybridView.hybridDelegate=self;
    hybridView.viewController=self;
    
    
    plugins=@{
              @"openInApp":[[BrowserPlugin alloc] initWithHybridView:hybridView],
              @"wx": [[WXPlugin alloc] initWithHybridView:hybridView],
              @"ali": [[AliPlugin alloc] initWithHybridView:hybridView],
              @"getLocation": [[LocationPlugin alloc] initWithHybridView:hybridView],
              @"image": [[ImagePlugin alloc] initWithHybridView:hybridView],
              @"qq": [[QQPlugin alloc] initWithHybridView:hybridView],
              @"system": [[SystemPlugin alloc] initWithHybridView:hybridView],
              @"cmbpay": [[CMBPayPlugin alloc] initWithHybridView:hybridView],
              @"assets": [[AssetsPlugin alloc] initWithHybridView:hybridView]
            };

    
    [hybridView loadUrl:@"files/index.html"];
    
    //[hybridView loadUrl:@"http://www.baidu.com/"];
    //[hybridView loadUrl:@"http://192.168.0.104:5559/"];
    //[hybridView loadUrl:@"http://10.0.78.168:5559/"];
    
    NSLog(@"width %f",[[UIScreen mainScreen] bounds].size.width);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)viewDidUnload
{
    
    NSString *key;
    
    for (key in plugins) {
        NSLog(@"%@", key);
    }
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue]; // 这里得到了键盘的frame
    // 你的操作，如键盘出现，控制视图上移等
    
    NSLog(@"height:%f",keyboardRect.size.height);
    
    CGRect origionRect = hybridView.webView.frame;
    CGRect newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, origionRect.size.width, [[UIScreen mainScreen] bounds].size.height-keyboardRect.size.height);
    hybridView.webView.frame = newRect;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    // 获取info同上面的方法
    // 你的操作，如键盘移除，控制视图还原等
    
    hybridView.webView.frame = [[UIScreen mainScreen] bounds];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


- (void)callNativeApi:(UIHybridView*)webView command:(NSDictionary *)command {
    
    NSString *method = [command objectForKey:@"method"];
    HybridAction *plugin = [plugins objectForKey:method];
    
    NSLog(@"execute %@",method);

    
    if (plugin) {
        [plugin execute:command];
        return;
    }
    
    NSString *callback = [command objectForKey:@"callback"];
    
    if ([method isEqualToString:@"statusBar"]) {
        
        NSString *style=[command objectForKey:@"params"];
        
        
        if ([style isEqualToString:@"dark"]||[style isEqualToString:@"1"]) {

            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }
        
        //[self setNeedsStatusBarAppearanceUpdate];
        
    } else if  ([method isEqualToString:@"open"]) {
        NSString *params=[command objectForKey:@"params"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:params]];
        
    } else if ([method isEqualToString:@"getDeviceToken"]){
        NSString *key=@"DeviceToken";
        NSData *token= [[NSUserDefaults standardUserDefaults]objectForKey:key];
        
        [hybridView callback:callback params:@{
                                               @"token":token
                                               }];
        
    } else if ([method isEqualToString:@"post"]) {
        
        NSDictionary *params=[command objectForKey:@"params"];
        NSString *url=[params objectForKey:@"url"];
        NSDictionary *data=[params objectForKey:@"data"];
        NSDictionary *files=[params objectForKey:@"files"];
        
        NSLog(@"start upload %@",url);
        
        [HttpUtil post:url data:data files:files completion:^(NSString *result){
            [hybridView callbackWithString:callback params:result];
        }];
        
    } else if ([method isEqualToString:@"getRect"]) {
        CGRect rect = [webView.webView frame];
        
        [hybridView callbackWithString:callback params:[@"" stringByAppendingFormat:@"%f,%f",rect.size.width,rect.size.height]];
        
    }
}


-(NSString*)toJsString:(NSString *)s
{
    return [NSString stringWithFormat: @"\"%@\"", [[[s stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""] stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"] stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]];
}


- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"开始摇动手机");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion ==UIEventSubtypeMotionShake )
    {
        NSLog(@"stop");
        [hybridView evaluateJavaScript:@"app_trigger(\"motion\")"];
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"取消");
}

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}

@end
