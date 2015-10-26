//
//  SVModalWebViewController.m
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "CPModalWebViewController.h"
#import "CPWebViewController.h"

@interface CPModalWebViewController ()

@property (nonatomic, strong) CPWebViewController *webViewController;

@end

@interface CPWebViewController (DoneButton)

- (void)doneButtonTapped:(id)sender;

@end


@implementation CPModalWebViewController

#pragma mark - Initialization


- (instancetype)initWithAddress:(NSString*)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL *)URL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:URL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest *)request {
    self.webViewController = [[CPWebViewController alloc] initWithURLRequest:request];
    if (self = [super initWithRootViewController:self.webViewController]) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone
                                                                                    target:self.webViewController
                                                                                    action:@selector(doneButtonTapped:)];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            self.webViewController.navigationItem.leftBarButtonItem = doneButton;
        else
            self.webViewController.navigationItem.rightBarButtonItem = doneButton;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    self.webViewController.title = self.title;
    self.navigationBar.tintColor = self.barsTintColor;
}

#pragma mark - Delegate

- (void)setWebViewDelegate:(id<UIWebViewDelegate>)webViewDelegate {
    self.webViewController.delegate = webViewDelegate;
}

- (id<UIWebViewDelegate>)webViewDelegate {
    return self.webViewController.delegate;
}

@end
