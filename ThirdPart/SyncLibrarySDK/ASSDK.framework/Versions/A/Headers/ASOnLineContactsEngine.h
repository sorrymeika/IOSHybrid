//
//  ASOnLineContactsEngine.h
//  iContact
//
//  Created by Hower on 11-4-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASSuperNetworkEngine.h"

@protocol ASOnLineContactsEngineDelegate <NSObject>
@optional

/**
 *  查询成功回调
 *
 *  @param contactsCount 云端联系人数量字符串
 */
- (void)contactCountSuccess:(NSString*)contactsCount;

/**
 *  查询失败
 *
 *  @param errorCode 错误码
 *  @param str       错误信息
 */
- (void)contactCountFail:(NetErrorCode)errorCode withStr:(NSString*)str;

@end


@interface ASOnLineContactsEngine : ASSuperNetworkEngine

@property (nonatomic,weak)id<ASOnLineContactsEngineDelegate> delegate;

+ (NSDictionary *)cgiParameters;

/**
 *  发起查询云端联系人数量网络请求
 */
- (void)start;

/**
 *  请求是否正在运行
 *
 *  @return YES，正在请求；NO，请求结束或没发起请求
 */
- (BOOL)isRunning;

/**
 *  登陆成功后
 *
 *  查询一下平台的联系人数量
 */
- (void)checkContactsCountAfterLogin;

@end
