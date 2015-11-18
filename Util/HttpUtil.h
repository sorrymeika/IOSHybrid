//
//  NSObject+ViewUtil.h
//  Letsgo
//
//  Created by 孙路 on 15/8/13.
//  Copyright (c) 2015年 Miku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpUtil : NSObject{
}

+ (void)post:(NSString *)url data:(NSDictionary *)data files:(NSDictionary *)files completion:(void (^)(NSString *results))completion;

@end
