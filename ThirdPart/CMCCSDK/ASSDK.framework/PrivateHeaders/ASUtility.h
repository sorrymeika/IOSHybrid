//
//  ASUtility.h
//  ASBasicLibrary
//
//  Created by likid1412 on 10/14/14.
//  Copyright (c) 2014 Aspire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASUtility : NSObject

@property (copy, nonatomic) NSString *deviceToken;

+ (instancetype)shared;

/**
 *  获取 Document 文档路径
 *
 *  @return Document 文档路径
 */
+ (NSString *)documentPath;

@end
