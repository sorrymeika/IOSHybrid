//
//  AppDelegate.m
//  Abs
//
//  Created by Miku on 13-10-7.
//  Copyright (c) 2013年 Miku. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApiManager.h"
#import "ViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "QQApiManager.h"

#import <ASSDK/ASSDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                             |UIUserNotificationTypeSound
                                                                                             |UIUserNotificationTypeAlert)
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
        
    } else {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge
                                                         |UIRemoteNotificationTypeSound
                                                         |UIRemoteNotificationTypeAlert)];
    }
    
    [self configures];
    
    
    [[[NSBundle mainBundle] infoDictionary] valueForKey:@"key"];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    NSDictionary *infoDict= [[NSBundle mainBundle] infoDictionary];
    
    NSString *newUagent = [NSString stringWithFormat:@"%@/SLApp %@(%@)",secretAgent,
                           [infoDict objectForKey:@"CFBundleVersion"],[infoDict objectForKey:@"CFBundleShortVersionString"]];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":newUagent}];
    
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] init];
    self.window.rootViewController = self.viewController;
    
    //    NSDictionary *dict = @{
    //                           };
    //    NSLog(@"%d",[[dict objectForKey:@"test"] intValue]?:-1);
    //    
    
    //[NSThread sleepForTimeInterval:1.5];
    
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //向微信注册
    [WXApi registerApp:@"wx736fd22e825a9ce5" withDescription:@"ABS家居"];
    
    
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104874974" andDelegate:[QQApiManager getInstance]];
    /*
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_SHARE,
                            nil];
    [self.tencentOAuth authorize:permissions inSafari:NO];
     */

    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    NSString *urlStr =[url absoluteString];
    
    if ([urlStr hasPrefix:@"wx"])
    {
        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    else if ([urlStr hasPrefix:@"tencent"])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    else if ([urlStr hasPrefix:@"abschinapp"])
    {
        return true;
    }
    return false;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]]||[TencentOAuth HandleOpenURL:url];;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"%@",self.viewController);
}


- (void)configures
{
    
    // 设置 SDK 渠道，不可为空
    // **重要** SDK 渠道需要向通讯录 SDK 接口负责人申请
    [ASSyncLibraryManager setSDKChannel:@"mcontact_sdk_fujianhshbfios"];
    
    // 初始化
    [ASSyncLibraryManager initializeSyncLibrary];
    
    // 开启日志输出
    [ASSyncLibraryManager setLogEnabled:YES];
    
    // 设置 ApnsManager
//    [[ASApnsManager sharedManager] setDelegate:self];
//    // 处理 SDK token 注册，需要在每次启动时调用
//    [[ASApnsManager sharedManager] processSyncSDKTokenRegisterOnCompletion:^{
//        ;
//    } onError:^(NSInteger code, NSString *message) {
//        ;
//    }];
    
    // 获取联系人权限
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        [ASSyncLibraryManager accessToContacts];
//    });
}


//在此接收设备令牌
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *key=@"DeviceToken";
    NSData *oldToken= [[NSUserDefaults standardUserDefaults]objectForKey:key];
    if (![oldToken isEqualToData:deviceToken]) {
        [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:key];
    }
    NSLog(@"device token:%@",deviceToken);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",error.localizedDescription);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"receiveRemoteNotification,userInfo is %@",userInfo);
}

@end
