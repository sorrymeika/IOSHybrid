//
//  WebViewController.h
//  WebBrowser
//
//  Created by sl on 15/10/8.
//  Copyright © 2015年 Trendpower. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic, copy) NSURLRequest *request;


- (instancetype)initWithAddress:(NSString *)urlString;

- (instancetype)initWithURL:(NSURL*)pageURL;

- (instancetype)initWithURLRequest:(NSURLRequest *)request;

@end
