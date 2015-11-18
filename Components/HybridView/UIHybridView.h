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

-(void)loadRequestWidthAddress:(NSString *)address;

-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;

@property (nonatomic, assign) id<UIHybridViewDelegate> hybridDelegate;
@property (nonatomic, retain) UIViewController* viewController;

-(void)callback:(NSString *)callback params:(NSDictionary*) params;
@end

@protocol UIHybridViewDelegate
- (void)callNativeApi:(UIHybridView*)view command:(NSDictionary *)command;
@end

