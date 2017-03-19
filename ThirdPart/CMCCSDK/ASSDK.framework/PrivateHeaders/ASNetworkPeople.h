//
//  ASNetworkPeople.h
//  CaiYun
//
//  Created by hower_new on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  获取备份上传的联系人数据

#import <Foundation/Foundation.h>

@interface ASNetworkPeople : NSObject

/*
 获取联系人上传的 JSON 格式
 
 @param aRecord 联系人的 recordRef
 @param namesDict @{组ID: 组名, ...}
 @param contactGroupsDict @{联系人ID: 组ID数组, ...}
 @return @{联系人属性字段: 联系人属性值, ...}
 ps: 联系人属性字段由平台提供
 */
+ (NSMutableDictionary*)loadContactToNetwork:(ABRecordRef)aRecord contactGroups:(NSDictionary*)contactGroupsDict groupName:(NSDictionary*)namesDict;




@end
