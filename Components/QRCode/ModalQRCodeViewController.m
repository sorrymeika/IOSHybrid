//
//  ModalQRCodeViewController.m
//  CMCC
//
//  Created by 孙路 on 17/3/10.
//  Copyright © 2017年 Miku. All rights reserved.
//

#import "ModalQRCodeViewController.h"
#import "QRCodeViewController.h"
#import "DismissTransition.h"
#import "PresentTransition.h"

@interface ModalQRCodeViewController ()


@end

@implementation ModalQRCodeViewController

- (instancetype)init {
    
    self.viewController = [[QRCodeViewController alloc] init];
    
    self = [super initWithRootViewController:self.viewController];
    
    self.transitioningDelegate = self;
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[PresentTransition alloc] init];
}

// dismiss动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[DismissTransition alloc] init];
}


@end
