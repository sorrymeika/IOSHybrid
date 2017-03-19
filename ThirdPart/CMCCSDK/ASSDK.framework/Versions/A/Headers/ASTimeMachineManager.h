//
//  ASTimeMachineManager.h
//  ASSyncLibraryProject
//
//  Created by lusonglin on 15-3-16.
//
//

#import <Foundation/Foundation.h>
#import "ASContactGitPointObject.h"

@interface ASTimeMachineManager : NSObject



/**
 *  单例模式
 *
 *  @return
 */
+ (instancetype)share;




/**
 * 查询时光机还原点列表
 * offset 分批请求的偏移位置，默认为0
 * rowCount 分批请求的偏移量，默认10
 */
- (void)getContactGitList:(NSString *)offset
                 rowCount:(NSString *)rowCount
                onSuccess:(ASSuccessBlockWithobject)successBlock
                  onError:(ASErrorBlock)errorBlock;

/**
 * 根据备份版本号，还原时光机联系人
 * sourceType 操作来源：1，WEB(默认)；2，WAP；
 3，客户端；4，自动触发；5，开放平台
 * versionId  时光机备份版本号
 */
-(void)pullContactGit:(NSString *)sourceType
            versionId:(NSString *)versionId
           onProgress:(ASProgressBlock)progress
            onSuccess:(ASSimpleBlock)successBlock
              onError:(ASErrorBlock)errorBlock;

/**
 * 查询还原点详情
 * 根据版本号id查询时光机版本日志详情
 * versionId  时光机备份版本号
 */
-(void)GetContactGitDetail:(ASContactGitPointObject *)pointObj
                 onSuccess:(ASSuccessBlock)successBlock
                   onError:(ASErrorBlock)errorBlock;

/**
 * 查询联系人版本列表
 * 根据联系人id查询联系人版本列表
 * contactid  联系人ID
 */
-(void)GetContactGitListHistory:(NSString *)contactid
                      onSuccess:(ASSuccessBlock)successBlock
                        onError:(ASErrorBlock)errorBlock;


@end
