//
//  KeyChainUtil.h
//  Abs
//
//  Created by 孙路 on 16/6/27.
//  Copyright © 2016年 Miku. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KeyChainUtil : NSObject{
}


+ (void)save:(NSString *)key data:(id)data;
+ (id) get:(NSString *)key;
+ (void)remove:(NSString *)key;

@end
