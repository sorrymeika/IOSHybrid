//
//  CPWebViewController.h
//

#import "UIKit/UIkit.h"

@interface CPWebViewController : UIViewController <UIWebViewDelegate>

- (instancetype)initWithAddress:(NSString*)urlString;
- (instancetype)initWithURL:(NSURL*)URL;
- (instancetype)initWithURLRequest:(NSURLRequest *)request;

@property (nonatomic, weak) id<UIWebViewDelegate> delegate;

@end
