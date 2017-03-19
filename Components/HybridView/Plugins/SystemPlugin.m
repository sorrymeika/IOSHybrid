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

#import <MessageUI/MessageUI.h>

@interface SystemPlugin (){
    
}
@end

@implementation SystemPlugin


-(void)execute:(NSDictionary *)command{
    NSString * callback=[command objectForKey:@"callback"];
    
    
    NSDictionary *params = [command objectForKey:@"params"];
    
    NSString * type= [params objectForKey:@"type"];
    
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
        
    } else if ([type isEqualToString:@"openPhoneCall"]||[type isEqualToString:@"phoneCall"]) {
        
        NSString *phoneNumber = [params objectForKey:@"phoneNumber"];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"telprompt://" stringByAppendingString:phoneNumber]]];
        
    } else if ([type isEqualToString:@"sendSMS"]) {
        
        NSString *phoneNumber = [params objectForKey:@"phoneNumber"];
        NSString *msg = [params objectForKey:@"msg"];
        
        [self showMessageView:phoneNumber withBody:msg];
        
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"sms://" stringByAppendingString:phoneNumber]]];
    }
    
}

- (void)showMessageView:(NSString *)phoneNumber withBody:(NSString *)body
{
    
    if ([MFMessageComposeViewController canSendText]) {
        
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //autorelease];
        
        controller.recipients = [NSArray arrayWithObject:phoneNumber];
        controller.body = body;
        controller.messageComposeDelegate = self;
        
        [_hybridView.viewController presentViewController:controller animated:YES completion:^{}];
        
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"发送短信"];//修改短信界面标题
    } else {
        
        [self alertWithTitle:@"提示信息" msg: @"设备没有短信功能"];
    }
}


//MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController: (MFMessageComposeViewController *)controller didFinishWithResult: (MessageComposeResult)result{
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    switch (result) {
            
        case MessageComposeResultCancelled:
            
            [self alertWithTitle:@"提示信息" msg: @"发送取消"];
            break;
        case MessageComposeResultFailed:// send failed
            [self alertWithTitle:@"提示信息" msg: @"发送成功"];
            break;
        case MessageComposeResultSent:
            [self alertWithTitle:@"提示信息" msg: @"发送失败"];
            break;
        default:
            break;
    }
}


- (void) alertWithTitle: (NSString *)title msg: (NSString *)msg {
    
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title
                                                     message:msg
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}




@end
