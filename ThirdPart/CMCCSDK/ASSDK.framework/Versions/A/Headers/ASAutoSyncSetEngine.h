//
//  ASAutoSyncSetEngine.h
//  CaiYun
//
//  Created by youming on 13-1-7.
//
//  自动同步开关设置

#import <Foundation/Foundation.h>
#import "ASSuperNetworkEngine.h"
#import "ASConfigNetSDK.h"

////////////////////////////////////////////////////////
#pragma mark - 自动同步开关
//自动同步开关
#define KAutoSyncSetEngineRequestStartNotification              @"KAutoSyncSetEngineRequestStartNotification"
#define KAutoSyncSetEngineRequestFinishNotification             @"KAutoSyncSetEngineRequestFinishNotification"
#define KAutoSyncSetEngineRequestFaildNotification              @"KAutoSyncSetEngineRequestFaildNotification"
#define KAutoSyncSetStateRequestingServerStateNotification      @"KAutoSyncSetStateRequestingServerStateNotification"
#define KAutoSyncSetStateRequestedServerStateNotification       @"KAutoSyncSetStateRequestedServerStateNotification"

#define kAutoSyncSetNotificationOpenStatus @"open"
#define kAutoSyncSetNotificationMsg         @"msg"


typedef NS_ENUM(NSInteger, AutoSyncSetMsgAlertType) {
    AutoSyncSetMsgAlertTypeNone = 0,//设置自动更新返回时无提示
    AutoSyncSetMsgAlertTypeAlert = 1,//普通提示
    AutoSyncSetMsgAlertTypeAccessDenies = 2,//无法读取通讯录
    AutoSyncSetMsgAlertTypePushNotification = 3,//自动同步依靠push通知。没有开启push通知，自动同步无法运行。
    AutoSyncSetMsgAlertTypeCancel = 4 // 取消设置同步的请求
};

//该通知在接收到AutoSyncSet通知后，可以在NSNotification的object获得
@interface AutoSyncSetMsg : NSObject

@property (nonatomic,strong) NSString *msg;//设置同步状态完成后的提示消息或错误消息
@property (nonatomic,assign) BOOL openState;//同步状态
@property (nonatomic,assign) AutoSyncSetMsgAlertType alertType;//提示消息的类型

@end

@protocol ASAutoSyncSetEngineDelegate <NSObject>
@optional

/**
 *  设置成功回调
 *
 *  @param str 设置成功的提示
 */
- (void)autoSyncSetSuccess:(NSString*)str;

/**
 *  设置失败的回调
 *
 *  @param errorCode 
 
 @discuss errorCode may be NSNetCodeAPNsDisabled or NSNetCodeAccessDenies. 
 If the [[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone, it will be NSNetCodeAPNsDisabled.
 In iOS8, if the [[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone, it will be NSNetCodeAPNsDisabled.
 If the user explicitly denied access to address book data, it will be NSNetCodeAccessDenies

 *  @param str Error Message
 */
- (void)autoSyncSetFail:(NetErrorCode)errorCode withStr:(NSString*)str;

@end


/**
 *  切换同步开关状态

 如果该次请求是关闭同步的，在请求结束时，将会清空映射
 */
@interface ASAutoSyncSetEngine : NSObject

/**
 *  ASAutoSyncSetEngine 单例
 *
 *  @return ASAutoSyncSetEngine 单例
 */
+ (ASAutoSyncSetEngine *)share;

/**
 *  释放 ASAutoSyncSetEngine 单例
 */
+ (void)release;

/**
 * (for SDK) 添加监听切换同步状态开始、完成和失败的消息方法

 KAutoSyncSetEngineRequestStartNotification 正在发起请求时 post
 KAutoSyncSetEngineRequestFinishNotification 请求结束时 post
 KAutoSyncSetEngineRequestFaildNotification 请求失败时 post

 设置完成后的消息可在 NSNotification 的 object 获取,消息类型为AutoSyncSetMsg
 在 NSNotification 的 userInfo 也能获取

 */
+ (void)addObserver:(id)observer startSelector:(SEL)start finishSelector:(SEL)finish faildSelector:(SEL)faild;

/**
 *  (for SDK) 移除 + (void)addObserver:(id)observer startSelector:(SEL)start finishSelector:(SEL)finish faildSelector:(SEL)faild 方法中监听的 notification
 *
 *  @param observer 上述方法中的 observer 参数
 */
+ (void)removeObserver:(id)observer;

@property (nonatomic,weak)id<ASAutoSyncSetEngineDelegate> delegate;

/**
 *  设置同步状态
 
 开启自动同步，如果开启成功将自动触发自动同步
 如果非自动同步正在运行，则无法设置自动同步状态，直接回调 autoSyncSetFail:withStr: ，errorCode 为 NSNetCodeSyncContactRunning

 调用 - (void)setAutoSyncState:(BOOL)open alertType:(AutoSyncSetMsgAlertType)type 方法，type 参数为 AutoSyncSetMsgAlertTypeNone

 *
 *  @param open YES，开启自动同步；NO，关闭自动同步
 */
- (void)setAutoSyncStateWithoutAlertType:(BOOL)open;

/**
 *  设置同步状态，并指定消息提示类型
 
 如果非自动同步正在运行，则无法设置自动同步状态，直接回调 autoSyncSetFail:withStr: ，errorCode 为 NSNetCodeSyncContactRunning
 *
 *  @param open YES，开启自动同步，如果开启成功将自动触发自动同步；NO，关闭自动同步
 *  @param type AutoSyncSetMsgAlertType 中的一种
 */
- (void)setAutoSyncState:(BOOL)open alertType:(AutoSyncSetMsgAlertType)type;

/**
 *  取消当前切换同步状态请求
 */
- (void)cancel;

/**
 *  检测切换同步状态请求是否正在运行
 *
 *  @return YES，正在运行；NO，没有运行
 */
- (BOOL)isRunning;

/**
 *  该方法已被弃置，请使用 setAutoSyncStateWithoutAlertType: 方法代替
 *
 */
- (void)autosynset:(BOOL)open __deprecated;

@end
