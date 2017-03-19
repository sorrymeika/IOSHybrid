//
//  DismissTransition.m
//  CMCC
//
//  Created by 孙路 on 17/3/10.
//  Copyright © 2017年 Miku. All rights reserved.
//

#import "DismissTransition.h"

@implementation DismissTransition

// 返回动画的时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController * exitVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * enterVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * container = [transitionContext containerView];
    
    
    CGRect initalFrame = [transitionContext initialFrameForViewController:exitVC];
    
    
    [container addSubview:enterVC.view];
    [container bringSubviewToFront:exitVC.view];
    
   // enterVC.view.frame = initalFrame;
    
    NSLog(@"%f %f", initalFrame.size.width, initalFrame.size.height);
    
    
    exitVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
    exitVC.view.layer.shadowOffset = CGSizeMake(-5,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    
    exitVC.view.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    exitVC.view.layer.shadowRadius = 4;//阴影半径，默认3
    
    
    exitVC.view.layer.transform = CATransform3DIdentity;
    
    enterVC.view.layer.transform = CATransform3DMakeTranslation(initalFrame.size.width/-2, 0, 0);
    
    // 动画
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:2 animations:^{
        exitVC.view.layer.transform = CATransform3DMakeTranslation(initalFrame.size.width, 0, 0);
        
        enterVC.view.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition: ![transitionContext transitionWasCancelled]]; // 如果参数写成yes，当用户取消pop时，会继续执行动画，也就是让detailVC消失，设置成这个参数，会避免这样的错误
    }];
}

@end
