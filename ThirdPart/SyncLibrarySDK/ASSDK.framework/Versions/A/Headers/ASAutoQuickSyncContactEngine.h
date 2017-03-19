//
//  AutoSyncContact.h
//  CaiYun
//
//  Created by kewenya on 06/01/13.
//
//  自动同步

#import <Foundation/Foundation.h>
#import "ASQuickSyncContactEngine.h"

typedef enum _StartType {
    Start_Default, // 默认发起同步
    Start_ContactChanged, // 联系人有变动
    Start_NeedCheckContactChanged // 需要检查联系人是否有变动，如果有，将发起同步。
}StartType;

@interface ASAutoQuickSyncContactEngine : ASQuickSyncContactEngine

/**
 *  本地自动同步开关，若置为 NO，调用 start 本地将不发起同步。由于设置自动同步开关 ASAutoSyncSetEngine 需要通过网络请求进行控制，所以设置了该本地变量。
 */
@property (nonatomic,assign) BOOL enabled;
@property (nonatomic,assign) BOOL contactChangedListenEnabled;//联系人变动发起同步的开关

/**
 *  用户手动发起或由内置定时器定时发起自动同步，联系人未改变，无需进行自动同步的 block 回调。可能由多次回调。
 */
@property (copy, nonatomic) ASSimpleBlock autoSyncDNSBlock;

/**
 *  ASAutoQuickSyncContactEngine 单例
 *
 *  @return ASAutoQuickSyncContactEngine 单例
 */
+ (ASAutoQuickSyncContactEngine *)share;

/**
 *  释放 ASAutoQuickSyncContactEngine 单例
 */
+ (void)release;

/**
 *  自动同步
 *
 *  @return YES，发起一次同步；NO，同步正在进行，不发起另一次同步
 */
- (BOOL)start;

/**
 *  发起一次自动同步
 
 根据联系人变动发起同步:若联系人变动发起同步的开关关闭，则不发起同步
 *
 *  @param type StartType
 */
- (void)start:(StartType)type;

@end
