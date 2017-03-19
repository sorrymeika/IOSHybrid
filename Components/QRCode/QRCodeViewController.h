//
//  CustomViewController.h
//  QRCode
//
//  Created by Mac_Mini on 15/9/15.
//  Copyright (c) 2015年 Chenxuhun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QRCodeDelegate <NSObject>

-(void)scanQRCodeSuccess:(UIViewController *)viewController result:(NSString *)result;

@end


typedef void(^QRUrlBlock)(NSString *url);
@interface QRCodeViewController : UIViewController<QRCodeDelegate>

@property (nonatomic, copy) QRUrlBlock qrUrlBlock;

@property (nonatomic, weak) id<QRCodeDelegate> delegate;

@end
