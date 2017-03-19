

#import <UIKit/UIKit.h>

@interface ModalWebViewController : UINavigationController<UIViewControllerTransitioningDelegate>

- (instancetype)initWithAddress:(NSString*)urlString;
- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithURLRequest:(NSURLRequest *)request;

@property (nonatomic, strong) UIColor *barsTintColor;
@property (nonatomic, weak) id<UIWebViewDelegate> webViewDelegate;

@end
