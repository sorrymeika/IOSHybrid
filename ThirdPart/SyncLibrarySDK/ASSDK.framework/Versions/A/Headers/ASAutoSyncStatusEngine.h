//  ASAutoSyncStatusEngine.h
//  CaiYun
//
//  查询自动同步状态
//
//  Created by kane on 14/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//  示例代码
//
//    ASAutoSyncStatusEngine *engine = [[ASAutoSyncStatusEngine alloc] init];
//    [engine queryStatusCompletion:^(BOOL isOpen) {
//        NSLog(@"自动同步状态成功: %@", isOpen ? @"开启" : @"关闭");
//    } onError:^(NSInteger errorCode, NSString *errorMessage) {
//        NSLog(@"获取同步状态失败: errorCode %d, errorMessage: %@", errorCode, errorMessage);
//    }];
//    [engine release];

#import <Foundation/Foundation.h>
#import "ASConfigNetSDK.h"

@interface ASAutoSyncStatusEngine : NSObject

// 成功回调
typedef void (^ASSSuccessBlock)(BOOL isOpen);

/**
 *  查询自动同步状态
 *
 *  @param successBlock 查询成功的回调，不可为空
 *  @param errorBlock   查询失败的回调，不可为空
 */
- (void)queryStatusCompletion:(ASSSuccessBlock)successBlock onError:(ASErrorBlock)errorBlock;

+ (NSDictionary *)cgiParameters;

@end