

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>

@protocol QQApiManagerDelegate <NSObject>

@optional

- (void)managerDidRecvShareResponse:(APIResponse*)response;

@end

@interface QQApiManager : NSObject<TencentSessionDelegate, TencentApiInterfaceDelegate, TCAPIRequestDelegate>

@property (nonatomic, assign) id<QQApiManagerDelegate> delegate;

+ (instancetype)getInstance;

@end
