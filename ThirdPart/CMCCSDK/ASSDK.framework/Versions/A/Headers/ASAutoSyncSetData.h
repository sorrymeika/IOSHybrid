//
//  ASAutoSyncSetData.h
//  CaiYun
//
//  Created by youming on 13-1-16.
//
//  因为需要切换登陆帐号时，该帐号自动同步状态上次未打开时，提示是否开启
//
//
//

#import <Foundation/Foundation.h>

@interface ASAutoSyncSetData : NSObject

/**
 *  保存用户自动同步的状态，并尝试发起一次自动同步
 *
 *  @param open 自动同步状态。如果 open 为 YES，则发起一次自动同步，否则不发起
 */
+ (void)saveAutoSyncStateAndTryStartAutoSync:(BOOL)open;

/**
 *  保存用户自动同步状态，startByType根据自动状态是否自动开始同步
 
 if 'open' and 'startByType' paramaters are all set to YES, then Auto Sync will start

 *
 *  @param open                     auto sync is enabled
 *  @param startAutoSyncIfEnabled   start auto sync if auto sync is enabled (open paramater is YES)
 */
+ (void)saveAutoSyncState:(BOOL)open startAutoSyncIfEnabled:(BOOL)startByType;

//获取用户的自动同步状态
+ (BOOL)getAutoSyncState;

//保存未联网时关闭自动同步缓存状态
+ (void)saveAutoSynCloseCache;

//删除未联网时关闭自动同步缓存状态
+ (void)deleteAutoSynCloseCache;

//查询用户是否存在于关闭自动同步缓存中
+ (BOOL)phoneExistAutoSynCloseCache;

@end
