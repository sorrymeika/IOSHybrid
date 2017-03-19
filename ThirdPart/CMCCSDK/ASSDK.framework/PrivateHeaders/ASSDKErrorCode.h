//
//  ASSDKErrorCode.h
//  ASSyncLibraryProject
//
//  Created by likid1412 on 6/4/14.
//
// 错误码 -- from Android

#ifndef ASSyncLibraryProject_ASSDKErrorCode_h
#define ASSyncLibraryProject_ASSDKErrorCode_h


/**
 * 公共模块
 */
static int MODE_TYPE_COMMON= 1;				//公共模块

/**
 * 登陆模块
 */
static int MODE_TYPE_LOGIN = 2;				//登陆模块

/**
 * 注册模块
 */
static int MODE_TYPE_REGIST = 3;				//注册模块

/**
 * 联系人及时同步
 */
static int MODE_TYPE_SYNC_TIMELY = 4;			//联系人及时同步

/**
 * 定时同步
 */
static int MODE_TYPE_SYNC_INTERVAL = 5; 		//定时同步

/**
 * 上传
 */
static int MODE_TYPE_SYNC_UPLOAD = 6;			//上传

/**
 * 下载
 */
static int MODE_TYPE_SYNC_DOWNLOAD = 7;		//下载

/**
 * 短信上传
 */
static int MODE_TYPE_MMS_UPLOAD = 8;			//短信上传

/**
 * 短信上传
 */
static int MODE_TYPE_MMS_DOWNLOAD = 9;			//短信下载

/**
 * 秒发
 */
static int MODE_TYPE_MMS_FAST =10;				//秒发

/**
 * 云名片
 */
static int MODE_TYPE_CLOUD_CARD=11;			//云名片

/**
 * 多媒体信息
 */
static int MODE_TYPE_MEDIA = 12;				//多媒体信息

/**
 * 查询联系人
 */
static int MODE_TYPE_QUERY_REMOTE_CONTACT= 13;		//查询联系人列表

/**
 * 短信上传
 */
static int OPERATE_COMMON_CODE = 0;			//通用操作码

/**
 * 身份认证
 */
static int OPERATE_SYNC_CHECK=1;				//身份认证

/**
 * 客户端本地读取联系人
 */
static int OPERATE_SYNC_LOCAL_READ=2;			//客户端本地读取联系人

/**
 * 发起同步请求
 */
static int OPERATE_SYNC_DATA_SUBMMIT=3;		//发起同步请求

/**
 * 联系人写入
 */
static int OPERATE_SYNC_LOCAL_WRITE=4;			//联系人写入

/**
 * 映射关系写入
 */
static int OPERATE_SYNC_RELATION_WRITE=5;		//映射关系写入

/**
 * ACK返回平台
 */
static int OPERATE_SYNC_ACK_SUBMMIT=6;			//ACK返回平台

/**
 * 短信身份验证
 */
static int OPERATE_MMS_CHECK=1;				//短信身份验证

/**
 * 联系人列表
 */
static int OPERATE_CONTACT_LIST = 0;			//查询联系人列表

/**
 * 联系人数量
 */
static int OPERATE_CONTACT_COUNT= 1;			//查询联系人数量

/**
 * 短信息同步
 */
static int OPERATE_MMS_SYNC=2;					//同步

/**
 * 查询个人详情
 */
static int OPERATE_CLOUDCARD_QUERY_PERSONAL_INFO=1;		//查询个人详情

/**
 * 更新个人详情
 */
static int OPERATE_CLOUDCARD_UPDATE_PERSONAL_INFO=2;		//更新个人详情

/**
 * 更新联系人详情
 */
static int OPERATE_CLOUDCARD_UPDATE_CONTACT_INFO=3;		//更新联系人详情

/**
 * 去飞聊平台登录失败
 */
static int ERRO_FEILIAO_LOGIN=-89;							//去飞聊平台登录失败

/**
 * 在号簿平台换飞聊平台身份验证出错
 */
static int ERRO_FEILIAO_CHECK=-90;							//在号簿平台换飞聊平台身份验证出错

/**
 * 不能直接获取到本机手机号（去立通上行验证出错）
 */
static int ERRO_CHECK_LOCAL_PHONE_NUMBER=-91;				//不能直接获取到本机手机号（去立通上行验证出错）

/**
 * 失败
 */
static int ERRO_FIAL=-92;									//失败

/**
 * 超时60秒没有获取到短信,超时
 */
static int ERRO_TIMEOUT=-99;								//超时

/**
 * 解析失败
 */
static int ERRO_PARSE_EXCEPTION=-98;						//解析失败

/**
 * 验证码获取
 */
static int ERRO_VERFYCODE =-97;							//验证码获取

/**
 * 超时60秒没有获取到短信
 */
static int ERRO_MMS_TIMEOUT=-96;							//超时60秒没有获取到短信


#endif
