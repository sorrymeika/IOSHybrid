//
//  ModalQRCodeViewController.h
//  CMCC
//
//  Created by 孙路 on 17/3/10.
//  Copyright © 2017年 Miku. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QRCodeViewController.h"

@interface ModalQRCodeViewController : UINavigationController<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) QRCodeViewController *viewController;

@end