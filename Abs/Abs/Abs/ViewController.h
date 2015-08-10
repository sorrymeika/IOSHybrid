//
//  ViewController.h
//  Abs
//
//  Created by Miku on 13-10-7.
//  Copyright (c) 2013年 Miku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZXingWidgetController.h"
#import "HybridView.h"

@interface ViewController : UIViewController<UIWebViewDelegate,AVAudioPlayerDelegate,HybridViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>
{
    
    HybridView *hybridView;
    UIAlertView *alert;
}

@property (strong, nonatomic) NSString *pickImageCallback;
-(void)loadDocument:(NSString *)docName;


@end


