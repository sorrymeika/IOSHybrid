

#import <UIKit/UIKit.h>

@interface CMBModalWebViewController : UINavigationController

- (instancetype)initWithAddress:(NSString*)urlString;

@property (nonatomic, strong) UIColor *barsTintColor;
@end
