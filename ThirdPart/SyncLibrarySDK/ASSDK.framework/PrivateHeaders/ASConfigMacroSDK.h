//
//  Macro.h
//  ASSyncLibraryProject
//
//  Created by Kane on 12/14/13.
//
//  宏定义

#ifndef ASSyncLibraryProject_Macro_SDK_h
#define ASSyncLibraryProject_Macro_SDK_h

//////////////////////////////////////////////////////////////////////////////////
#pragma mark - app
//////////////////////////////////////////////////////////////////////////////////

// 显示在about页，提交给移动cdc的版本号，错误日志，统计，向服务器注册设备
//用于app store升级，必须为三段式
#define KBundleVersion   [ASBasicManager bundleVersion]

#define KClient_id  @"1"    // 客户端ID【1:ios,2:v3,3:v5,4:android,5:wp7,6:wp8】

/*
 1，WEB(默认)；2，WAP；3，客户端；4，自动触发；5，开放平台
 */
#define kSourceType @"3"




//////////////////////////////////////////////////////////////////////////////////
#pragma mark - 渠道
//////////////////////////////////////////////////////////////////////////////////

// mcontact_sdk_cytxltxzspc // 福建通讯助手
// mcontact_huawei_sdk      // 华为sdk
// mcontact_suixinyi_sdk    // 随心仪
// mcontact_fetion_sdk      // 飞信
// mcontact_tongbutui       // 同步推
// mcontact_PP              // PP助手
// mcontact_ios163          // 网易
// mcontact_weiphone        // 威锋
// mcontact_91sj            // 91助手
// mcontact_admin           // appstore
// mcontact_apptest         // apptest
// mcontact_release_test    // release版测试
// mcontact_dev             // 开发



//////////////////////////////////////////////////////////////////////////////////
#pragma mark - 功能控制开关定义
//////////////////////////////////////////////////////////////////////////////////


// 除华为彩云 SDK 提供自动同步功能，其余 SDK 暂不提供 自动同步功能

/*
 福建通讯助手，仅提供以下功能
 1、  (智能同步 SDK 不提供！！！）通讯录智能同步（每天一次）
 2、  上传通信录（手机覆盖云端）
 3、  上传通信录（手机和云端合并）
 4、  下载通信录（云端覆盖手机）
 5、  下载通信录（云端和手机合并）
 */

/*
 飞信，不提供自动同步功能
 */

// 号簿管家升级开关 (如果要屏蔽，注释掉下面这行即可）
// SDK 需屏蔽该宏，否则可能导致SDK无法使用
//#define KHaoBuUpgradeEnable


//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constant Message
//////////////////////////////////////////////////////////////////////////////////

#define KNetErrorMsg @"请检查网络连接"
#define KNetErrorDefault @"对不起，网络异常，请稍候重试"
#define KUserGrantedAccessToContacts    @"您通讯录获取权限受限,请通过”设置>隐私>通讯录”中开启和通讯录的权限。"
#define KRemoteNotificationEanabled     @"您和通讯录推送通知权限受限,请通过”设置>通知>和通讯录”中开启和通讯录的通知权限后，才能使用智能同步功能"



//////////////////////////////////////////////////////////////////////////////////
#pragma mark - APNS UserDefaults Key
//////////////////////////////////////////////////////////////////////////////////

#define KApnsDeviceRegistered  @"apns_device_registered" // device是否已向平台注册
#define KApnsDeviceRegisteredToken  @"apns_device_registered_token" // 已向平台注册的device token (非aoi_token，而是设备的唯一标识)
#define KApnsAoiToken       @"apns_aoi_token"   // 推送token
#define KApnsRealTimeMsg    @"ApnsRealTimeMsg"      //收到推送消息界面实时处理




//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Notification
//////////////////////////////////////////////////////////////////////////////////

#define kNtfHttpRequestFailWithTriedConnectionFinished @"kNtfHttpRequestFailWithTriedConnectionFinished"
#define kNtfHttpRequestShouldResync @"kNtfHttpRequestShouldResync"
#define kKeyShouldResync @"kKeyShouldResync"




//////////////////////////////////////////////////////////////////////////////////
#pragma mark - Easy Macro
//////////////////////////////////////////////////////////////////////////////////

#define UserDefaults        [NSUserDefaults standardUserDefaults]

#define isJsonDictionaryHasKey(jsonDic, key) ([jsonDic isKindOfClass:[NSDictionary class]] && [jsonDic as_jsonObjectForKey:key])

#define isJsonDictionaryHasKeyForString(jsonDic, key)   (isJsonDictionaryHasKey(jsonDic, key) && [[jsonDic as_jsonObjectForKey:key] isKindOfClass:[NSString class]] && [(NSString *)[jsonDic as_jsonObjectForKey:key] length] > 0)

#define isJsonDictionaryHasKeyForDictionary(jsonDic, key)   (isJsonDictionaryHasKey(jsonDic, key) && [[jsonDic as_jsonObjectForKey:key] isKindOfClass:[NSDictionary class]])

#define isJsonDictionaryHasKeyForArray(jsonDic, key)   (isJsonDictionaryHasKey(jsonDic, key) && [[jsonDic as_jsonObjectForKey:key] isKindOfClass:[NSArray class]])

#define NSStringFromBool(x) (x) ? @"YES" : @"NO"

#define CFReleaseSafety(cf) do { if (cf) CFRelease((cf)); } while (0);

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - SystemVersion
////////////////////////////////////////////////////////////////////////////////////

#define HMSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define HMSystemVersionLessOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] <= version)
#define HMSystemVersionLessThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] < version)
#define HMSystemVersionGreaterThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] > version)


//////////////////////////////////////////////////////////////////////////////////
#pragma mark - NetWork
//////////////////////////////////////////////////////////////////////////////////

// 同步sdk for 华为使用的地址
#define KDefaultServerUrlForSyncLibraraySDK @"https://a.cytxl.com.cn/mcloud/jsonrpc_api.php"

// 同步sdk 使用的接口地址
#define KSDKMCloudServerURL   [[ASBasicManager model] sdkServerURL]              // 默认指向
#define kSDKRequestTimeOutInSeconds 60



////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 
////////////////////////////////////////////////////////////////////////////////////

#define ASCurrentStatisticChannel [[ASBasicManager model] SDKChannel]




////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Log
////////////////////////////////////////////////////////////////////////////////////

#define kASSyncSDKLogEnabledKey @"kASSyncSDKLogEnabledKey"
#define kASSyncSDKWriteLogEnabledKey @"kASSyncSDKWriteLogEnabledKey"


#   define DLog(fmt, ...) \
    do { \
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kASSyncSDKLogEnabledKey]) \
        { \
            NSLog((@"\n[ASSyncLog] %s [Line %d]\n " fmt @"\n\n"), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); \
        } \
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kASSyncSDKWriteLogEnabledKey]) \
        { \
            NSString *localLog = [NSString stringWithFormat:@"\n[ASSyncLog] %s [Line %d]\n" fmt "\n\n", __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]; \
            [[ASBasicManager model] writeLocalLog:@"%@", localLog]; \
        } \
    } while (0)

#   define DLogSimple(fmt, ...) \
    do { \
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kASSyncSDKLogEnabledKey]) \
        { \
            NSLog((@"\n[ASSyncLog] %s [Line %d]\n " fmt @"\n\n"), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); \
        } \
    } while (0)

#   define DLogObject(object) DLog("%@", object)
#   define ELog(err) {if(err) DLog(@"%@", err);}


#define ASWriteLog(fmt, ...) \
    do { \
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kASSyncSDKWriteLogEnabledKey]) \
        { \
            NSString *localLog = [NSString stringWithFormat:@"\n[ASSyncLog] %s [Line %d]\n" fmt "\n\n", __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]; \
            [[ASBasicManager model] writeLocalLog:@"%@", localLog]; \
        } \
    } while (0)




////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Exception
////////////////////////////////////////////////////////////////////////////////////

#define ASParamException(param) \
    do { \
        if (param == nil) \
        { \
            NSString *reason = (param == nil) ? @"" #param @" could not be nil" : @"" #param @" is empty string"; \
            [[NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil] raise]; \
        } \
    } while(0)

#endif
