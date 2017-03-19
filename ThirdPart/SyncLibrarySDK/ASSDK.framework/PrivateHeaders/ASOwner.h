//
//  ASOwner.h
//  iContact
//
//  Created by qiang he on 10-10-25.
//  Copyright 2010 Aspire. All rights reserved.
//  Maintain by Likid on 10/14/14
//  已登录的用户数据

#import <Foundation/Foundation.h>


#define KUsername @"username"
#define KUserId @"139userid"

@interface ASOwner : NSObject

@property (nonatomic, copy) NSString *phonenumber;
@property (nonatomic, copy) NSString *session;//auth平台业务票据
@property (nonatomic, copy) NSString *user_id;//和通讯录用户id
@property (nonatomic, copy) NSString *pass_id;//统一认证通行证号
@property (nonatomic, strong) NSDate *expireTime;//失效时间

@property (nonatomic, copy)  NSString *mobile;  // 用户绑定的手机号（现在phonenumber只是作为用户名）

+ (instancetype)share;
- (id)initWithUserInfo:(NSString*)user session:(NSString*)userSession userid:(NSString*)userid;

@end
