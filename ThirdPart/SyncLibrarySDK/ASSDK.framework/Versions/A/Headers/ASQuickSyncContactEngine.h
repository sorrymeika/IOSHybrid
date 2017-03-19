//
//  ASQuickSyncContactEngine.h
//  CaiYun
//
//  Created by kewenya on 12-6-15.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASSyncNetworkEngine.h"

@protocol ASQuickSyncContactsDelegate <ASSyncNetworkEngineDelegate>

/**
 *  自动同步本地联系人大量变动回调

 自动同步过程中，若发现本地联系人有大量变动（超过 50 人）。此时同步暂停，调用该类的 syncContinue 继续同步；调用该类的 cancelWithObject:KSyncCancel_SyncAlertView 中断同步（必须要使用 KSyncCancel_SyncAlertView 参数）

 如果没有实现该方法，有可能不会继续进行同步，导致同步失败，停留在 2% 的进度
 *
 *  @param syncEngine 请求该回调的 ASSyncNetworkEngine 对象
 *  @param count      变动的联系人数量
 */
- (void)contactChangedOutOfRange:(ASSyncNetworkEngine *)syncEngine changedCount:(NSUInteger)count;

@end

@interface ASQuickSyncContactEngine : ASSyncNetworkEngine {
	
    id writebackJson;
	
	
	NSUInteger totalCount;
}

@property (weak, nonatomic) id<ASQuickSyncContactsDelegate> delegate;

/*
 由于统一使用快同步，需要多次调用快同步，故在此使用单例 - by Likid 2013/07/05
 */
+ (ASQuickSyncContactEngine *)sharedEngine;

/**
 *  快同步
 *
 *  @return YES，发起一次快同步；NO，快同步正在进行，不发起另一次快同步
 */
- (BOOL)start;

@end
