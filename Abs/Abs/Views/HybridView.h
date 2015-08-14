//
//  JavaScriptAlert.h
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//

@protocol HybridViewDelegate;

@interface HybridView:UIWebView {
}


-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;

@property (nonatomic, assign) id<HybridViewDelegate> hybridDelegate;
@end

@protocol HybridViewDelegate
- (void)callNativeApi:(HybridView*)view command:(NSDictionary *)command;
@end

