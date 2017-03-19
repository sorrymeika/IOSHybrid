//
//  ASUploadContactEngine.h
//  iContact_Asyn_Test
//
//  Created by Hower on 11-4-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


/*
 功能描述：
 上传本地通讯录联系人到网络端：清空平台侧数据，使用客户端数据覆盖平台侧数据
 */

#import <Foundation/Foundation.h>
#import "ASSyncNetworkEngine.h"

@interface ASUploadContactEngine : ASSyncNetworkEngine

/**
*  上传(覆盖)，默认调用该方法
*
*  @return YES，发起一次上传；NO，上传正在进行，不发起另一次上传
*/
- (BOOL)start;

/**
 *  增量上传
 *
 *  @return YES，发起一次上传；NO，上传正在进行，不发起另一次上传
 */
- (BOOL)startWithDelta;


@end
