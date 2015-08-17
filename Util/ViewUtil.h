//
//  NSObject+ViewUtil.h
//  Letsgo
//
//  Created by 孙路 on 15/8/13.
//  Copyright (c) 2015年 Miku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewUtil : NSObject{
}

+ (void) alert:(NSString*)message cancelButtonTitle:(NSString*) title;
+ (void) alert:(NSString*)message;
+ (void)loadDocument:(UIWebView *)webView url:(NSString *)url;

@end
