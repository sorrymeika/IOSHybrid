
#import "ModalWebViewController.h"
#import "WebViewController.h"
#import "DismissTransition.h"
#import "PresentTransition.h"

@interface ModalWebViewController ()

@property (nonatomic, strong) WebViewController *webViewController;

@end


@implementation ModalWebViewController


- (instancetype)initWithAddress:(NSString*)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL *)URL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:URL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest *)request {
    self.webViewController = [[WebViewController alloc] initWithURLRequest:request];
    
    self = [super initWithRootViewController:self.webViewController];
    
    self.transitioningDelegate = self;
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.webViewController.title = self.title;
    self.navigationBar.tintColor = self.barsTintColor;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[PresentTransition alloc] init];
}

// dismiss动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[DismissTransition alloc] init];
}

@end
