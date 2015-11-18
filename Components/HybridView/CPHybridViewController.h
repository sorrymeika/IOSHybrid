//
//  ViewController.h
//  Abs
//
//  Created by Miku on 13-10-7.
//  Copyright (c) 2013年 Miku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIHybridView.h"

@protocol CPHybridViewControllerDelegate
@optional
- (void)callNativeApi:(NSString *)method command:(NSDictionary *)command;
@end


@interface CPHybridViewController : UIViewController<UIWebViewDelegate,UIHybridViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>
{
    
    UIHybridView *hybridView;
    UIAlertView *alert;
}

- (instancetype)initWithAddress:(NSString*)urlString;
- (void)callNativeApi:(UIHybridView*)webView command:(NSDictionary *)command;

@property (strong, nonatomic) NSString *pickImageCallback;

@end



