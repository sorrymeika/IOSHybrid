//
//  ASBasicManager.h
//  ASBasicLibrary
//
//  Created by likid1412 on 10/16/14.
//  Copyright (c) 2014 Aspire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASBasicModel.h"

/**
 *  Private manager, using in SDK, not public
 
 Manager unity method

 */
@interface ASBasicManager : NSObject

+ (ASBasicModel *)model;
+ (void)setModel:(ASBasicModel *)model;

/**
 *  SDK 初始化
 */
+ (void)initializeManager;

/**
 *  获取 App 版本号
 
 提取的是 CFBundleShortVersionString 信息
 *
 *  @return 返回 App 当前版本号
 */
+ (NSString *)bundleVersion;


/*!
 @brief  设置 SDK 渠道
 
 **重要**
 SDK 渠道需要向通讯录 SDK 接口负责人申请
 
 @param channel SDK 渠道，不可为空
 */
+ (void)setSDKChannel:(NSString *)channel;

/**
 *  设置session、userID
 *
 *  @param session 账号登录成功后 web 端返回的 session 串，不可为空
 *  @param userID  账号登录成功后通过 ASAuthSessionEngine 的接口获取，不可为空
 */
+ (void)setSession:(NSString *)session userID:(NSString *)userID;

#pragma mark - Log

/**
 *  获取当前 SDK log 是否开启
 *
 *  @return YES，开启；NO，关闭
 */
+ (BOOL)isLogEnabled;

/**
 *  是否开启打印 SDK Log，默认不开启
 *
 *  @param enabled YES，开启；NO，关闭。Release 版本将自动关闭 log
 */
+ (void)setLogEnabled:(BOOL)enabled;

@end
