//
//  ASAuthSessionEngine.h
//  ASSyncLibraryProject
//
//  Created by kewenya on 09/05/13.
//
//

#import "ASConfigNetSDK.h"

@interface ASAuthSessionEngine : NSObject

/**
 *  获取 session 登陆信息
 *
 *  @param session      139 Token，不可为空或空字符串
 *  @param successBlock 登陆成功的回调，block 将附带一个 NSString 类型的 userID 参数，该值为 session 对应的 userID
 *  @param errorBlock   登陆失败的回调
 */
- (void)startWithSession:(NSString *)session
               onSuccess:(ASObjectBlock)successBlock
                 onError:(ASErrorBlock)errorBlock;



/*
 ThirdParty Login Success Json

 session	String	是	auth平台业务票据
 expire_time	String	是	失效时间，单位为秒
 user_id	String	是	彩云通讯录用户id
 pass_id	String	否	统一认证通行证号
 extra_data	JsonObject	否 扩展字段，暂时没用到
 */

/*!
 @brief  第三方令牌登录

 @param token        第三方令牌
 @param tokenType    token 类型，eg. "RCS"
 @param sourceID     统一认证业务平台 SourceID。请根据移动统一认证提供方确定 SourceID。
 @param successBlock 登录成功回调，返回 ThirdParty Login Success Json 格式
 @param errorBlock   登录失败回调
 */
- (void)loginWithThirdPartyToken:(NSString *)token
                       tokenType:(NSString *)tokenType
                        sourceID:(NSString *)sourceID
                       onSuccess:(ASObjectBlock)successBlock
                         onError:(ASErrorBlock)errorBlock;

@end
