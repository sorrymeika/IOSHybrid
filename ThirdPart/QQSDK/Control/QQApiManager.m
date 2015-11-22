//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "QQApiManager.h"

@implementation QQApiManager

#pragma mark - LifeCycle
+(instancetype)getInstance {
    static dispatch_once_t onceToken;
    static QQApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[QQApiManager alloc] init];
    });
    return instance;
}

- (void)tencentDidLogin
{
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
}

- (void)tencentDidNotNetWork
{
}

- (void)addShareResponse:(APIResponse*) response
{
    if (_delegate
        && [_delegate respondsToSelector:@selector(managerDidRecvShareResponse:)]) {
        [_delegate managerDidRecvShareResponse:response];
    }
}


@end
