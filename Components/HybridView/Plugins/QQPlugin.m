//
//  JavaScriptAlert.m
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//
#import "QQPlugin.h"
#import "FileUtil.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "QQApiManager.h"

@interface QQPlugin ()<QQApiManagerDelegate>{
    NSString *callback;
}
@end

@implementation QQPlugin

-(instancetype)initWithHybridView:(UIHybridView *)hybridView{
    self=[super initWithHybridView:hybridView];
    [QQApiManager getInstance].delegate=self;
    return self;
}

-(void)execute:(NSDictionary *)command{
    callback=[command objectForKey:@"callback"];
    
    NSDictionary *params = [command objectForKey:@"params"];
    
    NSString * type=[params objectForKey:@"type"];
    
    if ([type isEqualToString:@"shareLinkURL"]){
        NSString * linkURL=[params objectForKey:@"linkURL"];
        NSString * title=[params objectForKey:@"title"];
        NSString * description=[params objectForKey:@"description"];
        
        NSURL* url = [NSURL URLWithString:linkURL];
        
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"share.jpg"];
        NSData* data = [NSData dataWithContentsOfFile:path];
        
        QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:title description:description previewImageData:data];
        SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
        
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        [self handleSendResult:sent];
    }
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            [self setResult:false msg:@"App未注册"];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            [self setResult:false msg:@"发送参数错误"];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            [self setResult:false msg:@"未安装手Q"];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            [self setResult:false msg:@"API接口不支持"];
            break;
        }
        case EQQAPISENDFAILD:
        {
            [self setResult:false msg:@"发送失败"];
            break;
        }
        default:
        {
            NSLog(@"other");
            //[self setResult:true msg:@"成功"];
            break;
        }
    }
}

- (void)managerDidRecvShareResponse:(APIResponse*)response{
    if (response.retCode==0){
        [self setResult:true msg:@"成功"];
        
    } else {
        [self setResult:false msg:response.errorMsg];
    }
}

//客户端提示信息
- (void)setResult:(BOOL) success msg:(NSString *)msg
{
    [_hybridView callback:callback params:@{
                                            @"success": [NSNumber numberWithBool:success],
                                            @"msg": msg
                                            }];
}

@end