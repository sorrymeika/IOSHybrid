//
//  ASGetPushMsgEngine.h
//  CaiYun
//
//  Created by lusonglin on 13-4-11.
//
//  推送详细消息获取
//  ps: 需要先设置 msg_id 和 messageTypes 后，再调用 getPushMsgOnCompletion:onError: 方法进行获取


#import "ASMKNetworkKit.h"

#define KPushMessageTypeOperation   @"operation-msg"
#define KPushMessageTypeUpgrade     @"update-msg"
#define KPushMessageTypeAutoSync    @"auto-sync"

@interface ASGetPushMsgEngine : NSObject

// 如果msg_id不为空，则取单条消息，如果为空，则根据messageTypes取消息
@property (nonatomic,strong) NSString *msg_id;

// 是否获取自动同步消息 -- by kane 2013.5.2
// 需要根据当前同步开关的状态，来决定是否获取自动同步消息
@property (nonatomic,strong) NSArray *messageTypes;

/**
 *  获取推送详细消息
 *
 *  @param successBlock 查询成功的回调，回调的 object 为 NSArray，不可为空
 *  @param errorBlock   查询失败的回调，不可为空
 */
- (void)getPushMsgOnCompletion:(ASObjectBlock)successBlock
                       onError:(ASErrorBlock)errorBlock;

@end