

#import "CMBModalWebViewController.h"
#import "CMBWebViewController.h"

@interface CMBModalWebViewController ()

@property (nonatomic, strong) CMBWebViewController *webViewController;

@end

@interface CMBWebViewController (DoneButton)

- (void)doneButtonTapped:(id)sender;

@end


@implementation CMBModalWebViewController

#pragma mark - Initialization



- (instancetype)initWithAddress:(NSString *)urlString {
    self.webViewController = [[CMBWebViewController alloc] init];
    self.webViewController.url = urlString;
    
    if (self = [super initWithRootViewController:self.webViewController]) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    self.webViewController.title = self.title;
    self.navigationBar.tintColor = self.barsTintColor;
}

@end
