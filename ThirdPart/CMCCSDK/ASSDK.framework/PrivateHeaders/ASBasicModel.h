//
//  ASBasicModel.h
//  ASBasicLibrary
//
//  Created by likid1412 on 10/16/14.
//  Copyright (c) 2014 Aspire. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A model contain some basic methods, and can be inherited to override them to change the behaviour.
 */
@interface ASBasicModel : NSObject

/**
 *  sdk 服务器 url
 
 @attention 有默认值，一般情况下使用默认值即
 */
@property (copy, nonatomic) NSString *sdkServerURL;

@property (copy, nonatomic) NSString *pimServerURLString;

/**
 *  SDK 渠道，默认为 nil
 */
@property (copy, nonatomic) NSString *SDKChannel;

- (void)initilizeModel;

#pragma mark - Log

- (void)writeLocalLog:(NSString *)str, ... NS_FORMAT_FUNCTION(1, 2);

- (void)deleteLocalLog;

@end
