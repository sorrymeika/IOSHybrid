//
//  ASConfigNetSDK.h
//  CaiYun
//
//  Created by likid1412 on 1/13/14.
//
//  SDK 相关开放的宏定义

#ifndef ASSyncLibraryProject_ASConfigNet_SDK_h
#define ASSyncLibraryProject_ASConfigNet_SDK_h

////////////////////////////////////////////////////////
#pragma mark - Error Code

/**
 *  SDK 错误码
 */
typedef NS_ENUM(NSInteger, NetErrorCode)
{
    NSNetCodeDefault = -2,

    NSNetCodeNetError = -1,

    NSNetCodeSuccess = 0,

    NSNetCodeSessionUseless = 2,

    // Local Error

    /**
     *  联系人隐私权限受限
     */
    NSNetCodeAccessDenies,
    /**
     *  推送通知未开启
     */
    NSNetCodeAPNsDisabled,
    /**
     *  同步正在运行
     */
    NSNetCodeSyncContactRunning,

    // Server Error

	NSNetCodeUserNotExist = 107000,

    NSNetCodeUserFreeze = 107006,

    NSNetCodeUserLoginout = 107007,
    /**
     *  微博头像导入，手机号不正确
     */
    NSNetCodeInvalidAccount = 107008,

	NSNetCodePswError = 107009,

    /**
     *  非政企用户
     */
    NSNetCodeNotEnterpriseContactsUser = -32061,

    /**
     *  终端id不存在,请重新注册
     */
    NSNetCodeDeviceNotRegistered = -32074,

    /**
     *  版本更新，登录失败
     */
    NSNetCodeVersionUpdate = -32210,

    /**
     *  session过期
     */
    NSNetCodeSessionExpired = -32032,

    /**
     *  session认证失败
     */
    NSNetCodeSessionInvalid = -32034,

    /**
     *  老用户未注册通行证用微博帐号登录，和通讯录已全面升级为移动通行证，请注册后登录。
     */
    NSNetCodeOldNoRegLoginFail = -32224,

    /**
     *  和通讯录新用户则提示“帐号未注册，请注册后使用”
     */
    NSNetCodeNewNoRegLoginFail = -32229,

    /**
     *  密码过于简单，注册失败
     */
    NSNetCodePwdEasyRegFail = -32223,

    /**
     *  无个人名片
     */
    NSNetCodePersonalCardNil = -32323
};

typedef NS_ENUM(NSInteger, ASErrorCode)
{
    /**
     *  联系人隐私权限受限
     */
    ASErrorCodeAccessDenies = NSNetCodeAccessDenies,
    /**
     *  推送通知未开启
     */
    ASErrorCodeAPNsDisabled = NSNetCodeAPNsDisabled,
    /**
     *  自动备份模式错误
     */
    ASErrorCodeAutoBackModeError
};


/**
 *  判断错误码 a 是否是 session 失效的错误码
 *
 *  @param a 错误码
 *
 *  @return bool value, YES, session invalid; other wise, NO.
 */
#define ERROR_CODE_SESSION_INVALID(a)  (a == NSNetCodeSessionExpired || a == NSNetCodeSessionInvalid)


#pragma mark - Blocks

typedef void (^ASSuccessBlock) (NSDictionary *resultDic);
typedef void (^ASErrorBlock) (NSInteger code, NSString *message);
typedef void (^ASSimpleBlock) ();
typedef void (^ASObjectBlock) (id object);
typedef void (^ASErrorObjectBlock)(NSError *error);
typedef void (^ASSuccessObjectWithCountBlock) (NSInteger code, NSDictionary *resultDic);
typedef void (^ASSuccessBlockWithobject) (int count,id object);
typedef void (^ASProgressBlock)(double progress);

#endif
