//
//  NSObject+ViewUtil.h
//  Letsgo
//
//  Created by 孙路 on 15/8/13.
//  Copyright (c) 2015年 Miku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtil : NSObject{
}

+(NSString*)convertToJsString:(NSString *)source;

+(NSString*)stringify:(NSObject *)object;

+(NSString*)decodeUrl:(NSString *)url;

@end
