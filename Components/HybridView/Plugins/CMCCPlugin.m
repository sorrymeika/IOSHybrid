//
//  JavaScriptAlert.m
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//
#import "SystemPlugin.h"
#import "KeyChainUtil.h"
#import "StringUtil.h"
#import "sys/utsname.h"

@interface SystemPlugin (){
    
}
@end

@implementation SystemPlugin


-(void)execute:(NSDictionary *)command{
    NSString * callback=[command objectForKey:@"callback"];
    
    
    NSDictionary *params = [command objectForKey:@"params"];
    
    NSString * type=[params objectForKey:@"type"];
    
    if ([type isEqualToString:@"info"]){
        struct utsname systemInfo;
        uname(&systemInfo);
        
        NSString *deviceName = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
     
        NSLog(@"设备名称: %@",deviceName );
        
        NSString* KEY_UUID =@"cn.fjcmcc.CMCC.device_uuid";
        
        NSString* uuid = [KeyChainUtil get:KEY_UUID];
        
        //首次执行该方法时，uuid为空
        if ([uuid isEqualToString:@""] || !uuid)
        {
            uuid = [[NSUUID UUID] UUIDString];
            
            //将该uuid保存到keychain
            [KeyChainUtil save: KEY_UUID data:uuid];
            
        }
        
        NSLog(@"uuid=%@",uuid);
        
        
        [_hybridView callback:callback params:@{
                                                @"uuid": uuid,
                                                @"deviceName": deviceName
                                                }];
        
    } else {
        
    }
    
}


@end
