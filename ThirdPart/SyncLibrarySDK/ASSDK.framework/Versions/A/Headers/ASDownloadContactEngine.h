//
//  ASDownloadContactEngine.h
//  iContact_Asyn_Test
//
//  Created by Hower on 11-4-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASSyncNetworkEngine.h"

@interface ASDownloadContactEngine : ASSyncNetworkEngine {
	
}

// 单向下载和覆盖型下载，平台联系人为 0 时不可下载；还原下载则可以
/**
 *  下载(差异数据下载)
 *
 *  @return YES，发起一次下载；NO，下载正在进行，不发起另一次下载
 */
- (BOOL)start;

/**
 *  增量下载
 */
- (BOOL)startWithDelta;

/**
 *  还原下载
 将触发强制下载，即平台联系人为 0 依然可以下载，直接清空本地通讯录；
 */
- (BOOL)startForRestore;

@end
