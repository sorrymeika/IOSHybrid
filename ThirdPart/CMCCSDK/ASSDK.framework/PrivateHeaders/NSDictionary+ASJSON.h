//
//  NSDictionary+ASJSON.h
//  ASSyncLibraryProject
//
//  Created by likid1412 on 2/24/14.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ASJSON)

/**
 *  JSON string 解析后的 object 专用

 过滤 key 是 NSNull 的情况
 *
 *  @param aKey key Value
 *
 *  @return 如果 aKey 是 NSNull 类型，返回 nil
 */
- (id)as_jsonObjectForKey:(id)aKey;

/**
 *  解析 1 或 0 的标识值
 *
 *  @param key key value
 *
 *  @return 如果 key 是 @"1" ，则返回 YES，否则返回 NO
 */
- (BOOL)as_boolJsonValueForKey:(id)key;

@end
