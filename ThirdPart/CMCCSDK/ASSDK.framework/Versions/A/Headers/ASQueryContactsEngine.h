//
//  ASQueryContactsEngine.h
//  SyncLibrary
//
//  Created by hower_new on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ASSuperNetworkEngine.h"

@protocol ASQueryContactsEngineDelegate <NSObject>
@optional

/**
 *  查询成功回调
 *
 *  @param jsonResult Json 格式数据，详见 jsonResult 响应字段描述
 */
- (void)queryContactsSuccess:(id)jsonResult;

/**
 *  查询失败回调
 *
 *  @param errorCode 错误码
 *  @param errorMsg  错误信息
 */
- (void)queryContactsFail:(NetErrorCode)errorCode errorMsg:(NSString*)errorMsg;

@end

/*
 jsonResult 响应字段描述：

 字段名称	类型	必选	说明
 contact_count	string	是	返回的总个数(可以用于计算分页)
 contact_list	JsonObject	是	联系人详细信息

 contact_list响应字段描述：
 字段名称	类型	必选	说明
 contactId	String 	是	服务端的联系人ID
 contactUserId	String 	是	服务端的用户ID
 etag	String	否	联系人属性关联记号,参见http的ETag意义
 groupMap	JsonObject	否	所属分组,分组ID与分组名称对应关系
 groups	JsonObject	否	联系人和组的对应关系
 name	String	否	姓名
 familyName	String	否	姓
 givenName	String	否	名
 nickName	String	否	昵称
 middleName	String	否	中间名
 gender	String	否	性别
 prefix	String	否	头衔
 suffix	String	否	称谓
 birthday	JsonArray	否	生日
 anniversary	JsonArray	否	纪念日
 mobile	JsonArray	否	手机
 workMobile	JsonArray	否	工作手机
 homeMobile	JsonArray	否	家庭手机
 otherMobile	JsonArray	否	其他手机
 iphone	JsonArray	否	IPHONE
 email	JsonArray	否	电子邮箱
 workMail	JsonArray	否	工作电子邮箱
 homeMail	JsonArray	否	家庭电子邮箱
 otherMail	JsonArray	否	其他电子邮箱
 tel	JsonArray	否	电话
 workTel	JsonArray	否	工作电话
 homeTel	JsonArray	否	家庭电话
 otherTel	JsonArray	否	其他电话
 shortTelNum	JsonArray	否	电话短号
 carTel	JsonArray	否	车载电话
 fax	JsonArray	否	传真
 workFax	JsonArray	否	工作传真
 homeFax	JsonArray	否	家庭传真
 otherFax	JsonArray	否	其他传真
 BP	JsonArray	否	BP机
 fetion	JsonArray	否	飞信号
 qq	JsonArray	否	QQ号
 msn	JsonArray	否	MSN
 weibo	JsonArray	否	微博
 blog	JsonArray	否	博客
 personalInfo	JsonArray	否	个人资料
 address	JsonArray	否	地址
 homeAddress	JsonArray	否	家庭地址
 workAddress	JsonArray	否	工作地址
 otherAddress	JsonArray	否	其他地址
 assembleAddress	JsonArray	否	组合联动地址, 数组元素对象,包含属性:国家(state),地区(area),城市(city),街道(street),邮编(postalCode)
 homeAssembleAddress	JsonArray	否	组合联动家庭地址, 数组元素对象,包含属性: 国家(state),地区(area),城市(city),街道(street),邮编(postalCode)
 workAssembleAddress	JsonArray	否	组合联动工作地址, 数组元素对象,包含属性: 国家(state),地区(area),城市(city),街道(street),邮编(postalCode)
 otherAssembleAddress	JsonArray	否	组合联动其他地址, 数组元素对象,包含属性: 国家(state),地区(area),城市(city),街道(street),邮编(postalCode)
 state	JsonArray	否	国家
 city	JsonArray	否	城市
 postalCode	JsonArray	否	邮编
 pager	JsonArray	否	电报
 wirelessMachine	JsonArray	否	无线路由
 website	JsonArray	否	web网站
 workWebsite	JsonArray	否	工作web网站
 homeWebsite	JsonArray	否	家庭web网站
 otherWebsite	JsonArray	否	其他web网站
 company	JsonArray	否	公司
 companyWebsite	JsonArray	否	公司网站
 companyTelExchange	JsonArray	否	公司前台总机
 companyAddress	JsonArray	否	公司地址
 department	JsonArray	否	部门
 position	JsonArray	否	职位
 assembleOrg	JsonArray	否	组合联动组织,数组元素对象,包含属性: 公司(company),部门(department),职位(position)
 note	JsonArray	否	备注
 other	JsonObject	否	其他
 lastContactTime	String	否	最近联系时间
 createTime	String	否	创建时间
 lastModifiedTime	String	否	修改时间
 blackFlag	int	否	黑名单标记：0,非黑名单;1,黑名单
 commonFlag	int	否	常用标记：该值的大小对应常用联系人的顺序
 dataFromFlag	int	否	数据来源标记:0,web添加;1,手机上传;2,outlook插件;3,系统模板（csv）;4,号簿管家;5,G3通话;6,139邮箱;7,wap
 syncMobileFlag	int	否	与手机同步标记. 0,参与手机同步;1,不参与手机同步
 */

@interface ASQueryContactsEngine : ASSuperNetworkEngine

@property (nonatomic,weak) id <ASQueryContactsEngineDelegate> delegate;

/**
 *  发起查询云端联系人数据网络请求
 *
 *  @param offset 分批请求的偏移位置
 *  @param count  分批请求的偏移量
 */
- (void)startWithOffset:(NSInteger)offset count:(NSInteger)count;

@end
