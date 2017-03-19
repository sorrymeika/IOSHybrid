//  ASLogoutEngine.h
//  CaiYun
//
//  注销
//
//  Created by kane on 14/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//  示例代码
//
//    ASLogoutEngine *engine = [[ASLogoutEngine alloc] init];
//    [engine logoutCompletion:^() {
//        NSLog(@"注销成功");
//    } onError:^(NSInteger errorCode, NSString *errorMessage) {
//        NSLog(@"注销失败: errorCode %d, errorMessage: %@", errorCode, errorMessage);
//    }];
//    [engine release];

@interface ASLogoutEngine : NSObject

/**
 *  注销
 *
 *  @param successBlock 注销成功的回调，不可为空
 *  @param errorBlock   注销失败的回调，不可为空
 */
- (void)logoutCompletion:(ASSimpleBlock)successBlock onError:(ASErrorBlock)errorBlock;

@end