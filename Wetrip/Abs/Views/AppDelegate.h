//
//  AppDelegate.h
//  Abs
//
//  Created by Miku on 13-10-7.
//  Copyright (c) 2013年 Miku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
