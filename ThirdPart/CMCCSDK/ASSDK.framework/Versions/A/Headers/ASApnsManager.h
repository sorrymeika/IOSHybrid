//
//  ASApnsManager.h
//  CaiYun
//
//  Created by Apple on 06/01/13.
//
// Apns 管理器，包括设备注册，推送处理，网络联系人变动（通过推送下发）

#import <Foundation/Foundation.h>
#import "ASConfigNetSDK.h"

@class ASApnsManager;

@protocol ASApnsManagerDelegate <NSObject>

/**
 *  网络联系人大量变动回调
 
 调用 [[ASAutoQuickSyncContactEngine share] start]，直接进行同步；调用 [[ASAutoQuickSyncContactEngine share] cancelWithObject:KSyncReject]，取消同步（必须要使用 KSyncReject 参数）
 *
 *  @param message 服务器返回有关网络联系人大量变动的提示信息
 */
- (void)webContactsChangedOutOfRange:(NSString *)message;

@end

@interface ASApnsManager : NSObject

+ (ASApnsManager *)sharedManager;

@property (nonatomic, weak) id<ASApnsManagerDelegate> delegate;

/**
 *  是否正在消息详情请求。（避免并发请求，服务端暂时不支持）
 */
@property (nonatomic, assign, getter = isRequesting) BOOL requesting;

/**
 *  aoi token；apns device token；推送device token
 */
@property (weak, readonly) NSString *apnsDeviceToken;

/**
 *  app 的 push notification 设置是否为开启状态。模拟器直接返回 YES
 */
@property (readonly) BOOL isNotificationEnabled;

/**
 *  自动同步的序列号，配合服务器的存在；一次性使用，用后清空。
 */
@property (nonatomic, strong) NSString *autoSyncSN;

/**
 *  处理推送消息 (SDK用)

 调用该方法，将会获取平台数据变动情况，如果平台数据有变动，将直接发起自动同步。
 自动同步若未开启，将不做任何处理，可通过 ASAutoSyncStatusEngine 查询自动同步是否已开启
 
 如果推送是网络联系人大量变动（超过 50 人），则会回调 ASApnsManagerDelegate 的 webContactsChangedOutOfRange: 方法

 *
 *  @param notification 推送数据。一般为 - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo 中的 userInfo； 该值为 nil，将直接获取平台变动情况，如果有变动，将会直接发起同步。
 */
- (void)processRemoteNotification:(NSDictionary *)notification;

/**
 *  处理从平台侧获取的自动同步推送通知消息详情内容（彩云通讯录调用接口）
 *
 *  @param messageDic 推送通知的数据
 */
- (void)processAutoSyncMessage:(NSDictionary *)messageDic;

#pragma mark - Register SDK Token

/**
 *  处理 SDK token 注册，需要在每次启动时调用，建议在 application:didFinishLaunchingWithOptions: 中调用

 @discuss 内部调用
 *
 *  @param completionBlock 完成回调，如果通知有开启，将会直接回调该 block
 *  @param errorBlock      失败回调，errorCode为错误号，errorMessage为错误信息。如果注册失败，则不能使用 SDK 所有功能，需要重新注册
 */
- (void)processSyncSDKTokenRegisterOnCompletion:(ASSimpleBlock)completionBlock onError:(ASErrorBlock)errorBlock;

/**
 *  注册推送失败时，即系统回调了 application:didFailToRegisterForRemoteNotificationsWithError: ，则需要在该回调方法中调用

 @discuss 注册推送失败，SDK 将使用默认 token 进行注册，只能使用上传下载等同步功能，不能使用自动同步功能

 *  @param completionBlock 完成回调，如果无需注册，将会直接回调该 block
 *  @param errorBlock      失败回调，errorCode为错误号，errorMessage为错误信息。如果注册失败，则不能使用 SDK 所有功能，需要重新注册
 */
- (void)failedToRegisterRemoteNotificationOnCompletion:(ASSimpleBlock)completionBlock onError:(ASErrorBlock)errorBlock;

/**
 *  注册 SDK token，注册成功才能使用 SDK 功能，系统回调 application:didRegisterForRemoteNotificationsWithDeviceToken: 方法时调用
 *
 *  @param token deviceToken
 *  @param completionBlock 完成回调，如果无需注册，将会直接回调该 block
 *  @param errorBlock      失败回调，errorCode为错误号，errorMessage为错误信息。如果注册失败，则不能使用 SDK 所有功能，需要重新注册
 */
- (void)trySetToken:(NSString *)token onCompletion:(ASSimpleBlock)completionBlock onError:(ASErrorBlock)errorBlock;

/**
 *  注册推送
 *
 *  @param token           deviceToken
 *  @param completionBlock 完成回调，如果无需注册，将会直接回调该 block
 *  @param errorBlock      失败回调，errorCode为错误号，errorMessage为错误信息。如果注册失败，则不能使用 SDK 所有功能，需要重新注册
 */
- (void)setApnsDeviceToken:(NSString *)token onCompletion:(ASSimpleBlock)completionBlock onError:(ASErrorBlock)errorBlock;

@end
