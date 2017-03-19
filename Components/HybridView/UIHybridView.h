//
//  JavaScriptAlert.h
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//

@protocol UIHybridViewDelegate;

@interface UIHybridView:NSObject<UIScrollViewDelegate> {
}



@property (nonatomic, assign) id<UIHybridViewDelegate> hybridDelegate;
@property (nonatomic, retain) UIViewController* viewController;
@property (nonatomic, retain) UIView* webView;

@property NSString *WEBVIEW_TYPE;


-(UIHybridView *)initWithFrame:(CGRect)frame;

-(void)loadUrl:(NSString *)url;

-(void)evaluateJavaScript:(NSString *)js;

-(void)callback:(NSString *)callback params:(NSDictionary*) params;
-(void)callbackWithString:(NSString *)callback params:(NSString*) params;
@end

@protocol UIHybridViewDelegate
- (void)callNativeApi:(UIHybridView*)view command:(NSDictionary *)command;
@end
