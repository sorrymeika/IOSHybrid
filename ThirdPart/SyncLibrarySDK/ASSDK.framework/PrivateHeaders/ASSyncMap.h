//
//  ASSyncMap.h
//  CaiYun
//
//  Created by kewenya on 12-6-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
//  同步映射表

#import <Foundation/Foundation.h>

#define kSyncContactTypeMask (1 << 8)

/*
 SyncContactType, 根据 type 的类型获取同步映射表

 kSyncContactTypeManual and kSyncContactTypeAuto, 获取所有联系人
 kSyncContactTypeAutoIncrement, 获取变动联系人
 */
typedef enum {
    kSyncContactTypeManual          = 0x1,
    kSyncContactTypeAuto            = 0x2,
    kSyncContactTypeAutoIncrement   = kSyncContactTypeMask | 0x1,
}SyncContactType;

typedef enum {
    GetIsContactChangedType_PeriodCheck,    // 周期检查
    GetIsContactChangedType_AutoSync        // 自动同步
} GetIsContactChangedType;

@interface ASSyncMap : NSObject

/*SDate*)date

 @fn 获取变动的联系人 相对于当前本地通讯录
 @param lastContactsDate，最近一次的所有联系人变动的日期 key为(NSString *)localID，object为(N @return 增加和更新的联系人为联系人ID（NSString），需要删除的联系人为 ASSyncInfo
 */
+ (NSMutableArray*)getChangedContacts:(NSMutableDictionary*)lastContactsDate;

+ (BOOL)hasSynced;

/*
 与上次同步相比 当前通讯录是否有变更
 */
+ (BOOL)IsAddressBookDiffWithLastSync;

+ (NSMutableDictionary*)getUserSyncInfomation:(NSString*)user;

+ (BOOL)updateUserSyncInfomation:(NSString*)user dic:(NSMutableDictionary*)dic;

/*
 (仅供快速同步时用)
 return: ASSyncInfo对象的数组
 */
+ (NSMutableArray*)getNeedQuickSyncContacts:(NSString*)user type:(SyncContactType)type isChanged:(int*)contactChangedCount;

/*
 @fn 根据syncInfoArray获取ASSyncMap串

 @param syncInfoArray @[ASSyncInfo, ...]
 @return @{@"add_ids": IDs, @"update_ids": IDs, @"delete_ids": IDs}; 其中 IDs 为 @{sourseID: localID}
 */
+ (NSDictionary*)getSyncMapDic:(NSArray*)syncInfoArray;

/*
 清空原有map映射关系，更新Map表中的时间,清理同步状态改为KUnSynced
 */
+ (BOOL)clearMap:(NSString*)user;

/*
 批量清空map映射关系
 @param userIds @[user_id, ...]
 */
+ (void)clearMaps:(NSArray *)userIds;

/*
 更新ASSyncMap表
 syncInfos 同步回应过来的变动信息：主要是对于有sourseID的联系人；如果无sourseID，无需添加到syncInfos，此函数会自动处理
 */
+ (BOOL)updateMapWithSyncChanged:(NSString*)user syncInfos:(NSMutableArray*)syncInfos;

//+ (void)logSavedDate:(id)syncInfo originDate:(NSDate *)originDate;

@end
