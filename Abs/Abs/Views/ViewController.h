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

@interface ViewController : UIViewController<UIWebViewDelegate,AVAudioPlayerDelegate,UIHybridViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>
{
    
    UIHybridView *hybridView;
    UIAlertView *alert;
}

@property (strong, nonatomic) NSString *pickImageCallback;

@end


