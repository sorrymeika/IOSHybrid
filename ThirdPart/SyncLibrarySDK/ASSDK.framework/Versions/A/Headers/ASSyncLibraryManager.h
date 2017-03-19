//
//  ASSyncLibraryManager.h
//  CaiYun
//
//  Created by Apple on 22/03/13.
//
//

#import <Foundation/Foundation.h>

@class ASAddrBookObject;

@interface ASSyncLibraryManager : NSObject

/**
 *  同步 SDK 初始化
 */
+ (void)initializeSyncLibrary;

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

#pragma mark - Contacts

/**
 *  获取通讯录的权限（同步接口）

 iOS6 以上（包括 iOS6 ），需要获取通讯录权限，才能获取联系人数据

 重要：该方法在获取权限过程中将会阻塞当前线程，请尽量不要放在主线程运行

 *
 *  @return 是否允许获取。iOS6 以下直接返回 YES，iOS6 及以上，将会调用系统接口获取权限。
 */
+ (BOOL)accessToContacts;

/**
 *  实时获取的联系人数
 *
 *  @param error On error, contains error information. See “Address Book Errors”.
 *
 *  @return iOS 6以下（不包含 iOS 6）直接返回当前联系人数；
 iOS 6 及 iOS 6 以上，如果没有获得通讯录权限，返回 0；获取失败，返回 0，失败信息见 error 参数；获取成功，返回当前联系人数
 */
+ (NSUInteger)contactsCountForRealtime:(NSError **)error;

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
 *  @param enabled YES，开启；NO，关闭。
 */
+ (void)setLogEnabled:(BOOL)enabled;

@end
