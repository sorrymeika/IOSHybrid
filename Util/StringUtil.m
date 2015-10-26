//
//  NSObject+ViewUtil.m
//  Letsgo
//
//  Created by 孙路 on 15/8/13.
//  Copyright (c) 2015年 Miku. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil : NSObject


+(NSString*)convertToJsString:(NSString *)source
{
    return [NSString stringWithFormat: @"\"%@\"", [[[source stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""] stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"] stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]];
}

+(NSString*)stringify:(NSObject *)object
{
    if ([NSJSONSerialization isValidJSONObject:object]) {
        NSError *error;
        NSData *registerData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        return [[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+(NSString*)decodeUrl:(NSString *)url{
    return [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
