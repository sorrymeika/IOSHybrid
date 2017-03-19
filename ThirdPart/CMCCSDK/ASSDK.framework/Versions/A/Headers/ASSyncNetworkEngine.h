//
//  ASSyncNetworkEngine.h
//  CaiYun
//
//  Created by kewenya on 11/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASSuperNetworkEngine.h"
#import "ASConfigNetSDK.h"

////////////////////////////////////////////////////////
#pragma mark - Sync Cancel Type Object

/*
 同步取消类型

 1 网络联系人大量变动，拒绝同步时 KSyncReject
 2 本地联系人大量变动，拒绝同步时 KSyncCancel_SyncAlertView
 3 中断同步 KSyncCancelDefault
 */
#define KSyncCancelDefault @"SyncCancelDefault" // 默认，一般的终端同步
#define KSyncCancel_HttpTryAgain @"SyncCancel_HttpTryAgain" // 重试，SDK 调用者基本不需要使用到该参数
#define KSyncCancel_SyncAlertView @"SyncCancel_SyncAlertView" // 本地联系人大量变动，拒绝同步时，使用该参数
#define KSyncReject @"reject" // 网络联系人大量变动，拒绝同步时，使用该参数
#define kTryAgainText @"网络环境不稳定，请续传"

extern NSString *ASNtfSyncContactDidSuccess;
extern NSString *ASNtfSyncContactDidFailed;
extern NSString *ASNtfSyncContactDidCanceled;

extern NSLock *SyncLock;

@class ASSyncNetworkEngine;
@class ASSyncResult;

//SyncAction 现有的数值不能改，关系到备份历史记录
typedef enum  {
    SyncAction_Sync,                    //合并
	SyncAction_Upload,                  //上传
	SyncAction_Download,                //下载
    SyncAction_QSync        = 0x04,     //快速同步
    SyncAction_AutoSync     = 0x05,     //自动同步
    SyncAction_DownloadDelta,           //增量下载
    SyncAction_UploadDelta,             //增量上传
    SyncAction_DownloadRestore,         //还原下载
    SyncAction_QueryMcloud,
    SyncAction_DeleteMcloud
}SyncAction;

typedef enum  {
	SyncStep_Init = 0,//备份初始化 init
	SyncStep_SendData,//发送联系人数据包
	SyncStep_Ack      //ACK(目前快速同步中使用)
}SyncStep;

typedef enum {
    SyncAlertViewTag_LCancel_RContinue = 200,
    SyncAlertViewTag_LContinue_RCancel
}SyncAlertViewTag;

@protocol ASSyncNetworkEngineDelegate <NSObject>
@required

/**
 *  同步成功回调，结果可从 [syncEngine synResult]获取
 *
 *  @param syncEngine 发起同步的 engine
 */
- (void)syncContactSuccess:(ASSyncNetworkEngine*)syncEngine;

/**
 *  同步失败回调
 *
 *  @param syncEngine 发起同步的 engine
 *  @param errorCode  错误码
 *  @param errorMsg   错误信息
 */
- (void)syncContactFail:(ASSyncNetworkEngine*)syncEngine errorCode:(NetErrorCode)errorCode errorMsg:(NSString*)errorMsg;

/**
 *  同步进度回调
 *
 *  @param syncEngine  发起同步的 engine
 *  @param newProgress 同步进度，float 数值，范围 0.0 ~ 1.0
 */
- (void)syncNetworkEngine:(ASSyncNetworkEngine *)syncEngine progress:(float)newProgress;

@optional

/**
 *  上传同步数据回调
 *
 *  @param syncEngine  发起同步的 engine
 *  @param newProgress 上传进度，double 数值，范围 0.0 ~ 1.0
 */
- (void)syncNetworkEngine:(ASSyncNetworkEngine *)syncEngine uploadProgress:(double)progress;

- (void)syncNetworkEngine:(ASSyncNetworkEngine *)syncEngine progressText:(NSString*)text;

/**
 *  sync contact did canceled
 *
 *  @param syncEngine syncEngine
 *  @param canceledObject 同步取消类型，详见 cancelWithObject 方法说明
 */
- (void)syncContactDidCanceled:(ASSyncNetworkEngine *)syncEngine withObject:(id)canceledObject;

/**
 *  sync contact will start
 *
 *  @param syncEngine syncEngine
 */
- (void)syncContactWillStart:(ASSyncNetworkEngine *)syncEngine;

/**
 *  同步因数据大量变动（本地或网络）而暂停时，调用了 syncContinue 方法的回调
 *
 *  @param syncEngine syncEngine
 */
- (void)syncContactDidContinued:(ASSyncNetworkEngine *)syncEngine;

@end

@interface ASSyncNetworkEngine : ASSuperNetworkEngine

@property (nonatomic,weak)id<ASSyncNetworkEngineDelegate> delegate;
@property (nonatomic,strong)ASSyncResult *syncResult;
@property (nonatomic,assign)SyncAction syncAction;
@property (assign, getter = isSyncFinished) BOOL syncFinished; // 同步是否已结束。

@property (assign, nonatomic, readonly) SyncStep curStep;

@property (assign, readonly, nonatomic) NSTimeInterval retryDelay; // defualt value is 5.0f
@property (assign, readonly, nonatomic) NSInteger retryTimes; // defualt value is 3

/**
 *  是否需要续传

 通过 通知 来控制是否要续传
 kNtfHttpRequestFailWithTriedConnectionFinished 表示三次重连结束仍连接失败，由 网络层 post，外部 进行监听
 kNtfHttpRequestShouldResync 表示需要续传，由外部 post，在 ASHttpRequest 进行监听
 */
@property (assign, nonatomic) BOOL shouldResumeConnection;

/**
 *  获取正在运行的同步引擎
 *
 *  @return 如果正在同步，返回正在同步的引擎；否则，返回 nil
 */
+ (ASSyncNetworkEngine *)runningSyncNetworkEngine;

/**
 *  开始同步
 *
 *  @return  YES，发起一次同步；NO，同步正在进行，不发起另一次同步
 */
- (BOOL)start;

/**
 *  取消同步
 
 调用该类的 cancelWithObject: 方法，参数为 KSyncCancelDefault

 调用该方法后，由于数据处理，不会立即停止同步，通过 SyncNetworkEngineDelegate 的 syncContactDidCanceled:withObject: 回调标识取消同步成功

 @see SyncNetworkEngineDelegate
 */
- (void)cancel;

/**
 *  取消同步
 *
 *  @param object 同步取消类型

 同步取消类型

 1 网络联系人大量变动，拒绝同步时 KSyncReject
 2 本地联系人大量变动，拒绝同步时 KSyncCancel_SyncAlertView
 3 中断同步 KSyncCancelDefault

 */
- (void)cancelWithObject:(id)object;

/**
 *  同步因数据大量变动（本地或网络）而暂停时，调用该方法继续进行同步
 *  @see - (void)syncContinueWithSelector:(SEL)selector target:(id)target
 */
- (void)syncContinue;

/**
 *  set retry times and delay
 *
 *  @param retryTimes retry times
 *  @param retryDelay retry delay
 */
- (void)setRetryTimes:(NSInteger)retryTimes retryDelay:(NSTimeInterval)retryDelay;

/**
 *  取消备份时的回调
 
 @discuss This method is deprecated, suggeste using SyncNetworkEngineDelegate method - syncContactDidCanceled:withObject:
 *
 *  @param selector 回调方法
 *  @param target   回调的目标
 */
- (void)cancellWithSelector:(SEL)selector target:(id)target __deprecated;

/**
 *  同步将要开始时的回调
 
 @discuss This method is deprecated, suggeste using SyncNetworkEngineDelegate method - syncContactWillStart:
 *
 *  @param selector selector
 *  @param target   target
 */
- (void)syncWillStart:(SEL)selector target:(id)target __deprecated;

/**
 *  同步因数据大量变动（本地或网络）而暂停时，调用了 syncContinue 方法的回调
 
 @discuss This method is deprecated, suggeste using SyncNetworkEngineDelegate method - syncContactDidContinued:
 *
 *  @param selector selector
 *  @param target   target
 */
- (void)syncContinueWithSelector:(SEL)selector target:(id)target __deprecated;

#pragma mark - Sub Class Methods

// 以下方法仅供子类调用

- (BOOL)shouldCancel;

/*!
 @brief  write contacts into AddressBook
 
 **Important**
 If subclass won't write contacts, should not overide this method or call it. Otherwise, subclass must overide this method, and execute the code within background queue like this:
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
     // wirte contacts
 })
 
 Here, we use DISPATCH_QUEUE_PRIORITY_HIGH, as most of time, the write op is take a important task, so give the high priority to run more time

 */
- (void)writeContactsInBackground;

- (void)setUploadData:(NSDictionary *)dic;

- (void)setSync_sign:(NSString *)sync_sign;

//流量计数
- (int)getflowCount;

- (void)requestWithHttp:(SyncStep)step;

/*
 @fn 错误数据回应写入本地错误日志文件
 
 @param responseString 响应JSON
 @return 如果正常回应,返回 JSON 的 result 值; 否则返回 nil
*/
- (id)catchErrorResponse:(NSString*)responseString;

- (void)syncContactSuccess;

- (void)syncContactFail:(NetErrorCode)errorCode errorMsg:(NSString*)errorMsg;

- (void)setProgress:(float)newProgress;

- (void)setProgressText:(NSString*)text;

- (void)setTryAgainText:(NSString*)text;

- (BOOL)hasImplementCancelSelector;

@end
