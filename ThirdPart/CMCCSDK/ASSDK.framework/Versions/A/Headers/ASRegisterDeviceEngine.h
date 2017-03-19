//  ASRegisterDeviceEngine.h
//  CaiYun
//
//  向平台注册终端
//
//  Created by kane on 14/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ASConfigNetSDK.h"

@interface ASRegisterDeviceEngine : NSObject

/**
 *  向平台注册终端
 *
 *  @param successBlock 注册成功的回调，不可为空
 *  @param errorBlock   注册失败的回调，不可为空
 */
- (void)registerOnCompletion:(ASSimpleBlock)successBlock onError:(ASErrorBlock)errorBlock;

@end
