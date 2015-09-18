//
//  JavaScriptAlert.h
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//

@protocol UIHybridViewDelegate;

@interface UIHybridView:UIWebView {
}


-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;

@property (nonatomic, assign) id<UIHybridViewDelegate> hybridDelegate;
@end

@protocol UIHybridViewDelegate
- (void)callNativeApi:(UIHybridView*)view command:(NSDictionary *)command;
@end

