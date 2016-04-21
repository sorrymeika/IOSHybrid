//
//  JavaScriptAlert.m
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//
#import "WXPlugin.h"
#import "WXApiManager.h"
#import "payRequsestHandler.h"
#import "WXApiRequestHandler.h"
#import "FileUtil.h"
#import "HttpUtil.h"

@interface WXPlugin ()<WXApiManagerDelegate>{
    NSString *callback;
}
@end

@implementation WXPlugin

-(instancetype)initWithHybridView:(UIHybridView *)hybridView{
    self=[super initWithHybridView:hybridView];
    
    [WXApiManager sharedManager].delegate=self;
    return self;
}

-(void)execute:(NSDictionary *)command{
    callback=[command objectForKey:@"callback"];
    
    NSDictionary *params = [command objectForKey:@"params"];
    
    NSString * type=[params objectForKey:@"type"];
    
    if ([type isEqualToString:@"pay"]){
        NSString * spUrl=[params objectForKey:@"spUrl"];
        NSString * orderCode=[params objectForKey:@"orderCode"];
        NSString * orderName=[params objectForKey:@"orderName"];
        NSString * orderPrice=[params objectForKey:@"orderPrice"];
    
        [self sendPay:spUrl orderCode:orderCode orderName:orderName orderPrice:orderPrice];
        
    } else if ([type isEqualToString:@"shareLinkURL"]){
        NSString * linkURL=[params objectForKey:@"linkURL"];
        NSString * tagName=[params objectForKey:@"tagName"];
        NSString * title=[params objectForKey:@"title"];
        NSString * image=[params objectForKey:@"image"];
        NSString * description=[params objectForKey:@"description"];
        NSNumber * scene=[params objectForKey:@"scene"];
        
        enum WXScene wxScene;
        
        if ([scene isEqualToNumber:[NSNumber numberWithInteger:0]]){
            wxScene=WXSceneSession;
        } else {
            wxScene=WXSceneTimeline;
        }
        
        UIImage *thumbImage;
        
        NSLog(@"share image:%@",image);
        
        if (image==nil||[image isEqualToString: @""]) {
            thumbImage = [FileUtil pathToImage:@"default.png"];
        } else {
            thumbImage = [HttpUtil getImage:image];
        }
        
        
        [WXApiRequestHandler sendLinkURL:linkURL
                                 TagName:tagName
                                   Title:title
                             Description:description
                              ThumbImage:thumbImage
                                 InScene:wxScene];
    }
}


//spUrl:调用统一下单API的商户后台地址
- (void)sendPay:(NSString *)spUrl orderCode:(NSString *)orderCode orderName:(NSString *)orderName orderPrice:(NSString *)orderPrice
{
    //从服务器获取支付参数，服务端自定义处理逻辑和格式
    //订单标题
    //NSString *ORDER_NAME    = @"Ios服务器端签名支付 测试";
    //订单金额，单位（元）
    //NSString *ORDER_PRICE   = @"0.01";
    
    //根据服务器端编码确定是否转码
    NSStringEncoding enc;
    //if UTF8编码
    enc = NSUTF8StringEncoding;
    //if GBK编码
    //enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *urlString = [NSString stringWithFormat:@"%@?plat=ios&order_no=%@&product_name=%@&order_price=%@",
                           spUrl,
                           [orderCode stringByAddingPercentEscapesUsingEncoding:enc],
                           [orderName stringByAddingPercentEscapesUsingEncoding:enc],
                           orderPrice];
    
    
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError == nil) {
            // 网络请求结束之后执行!
            // 将Data转换成字符串
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                NSError *error;
                NSMutableDictionary *dict = NULL;
                //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
                dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                
                NSLog(@"url:%@",urlString);
                if(dict != nil){
                    NSMutableString *retcode = [dict objectForKey:@"retcode"];
                    if (retcode.intValue == 0){
                        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                        
                        //调起微信支付
                        PayReq* req             = [[PayReq alloc] init];
                        req.openID              = [dict objectForKey:@"appid"];
                        req.partnerId           = [dict objectForKey:@"partnerid"];
                        req.prepayId            = [dict objectForKey:@"prepayid"];
                        req.nonceStr            = [dict objectForKey:@"noncestr"];
                        req.timeStamp           = stamp.intValue;
                        req.package             = [dict objectForKey:@"package"];
                        req.sign                = [dict objectForKey:@"sign"];
                        [WXApi sendReq:req];
                        //日志输出
                        NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                    }else{
                        [self setResult:false msg:[dict objectForKey:@"retmsg"]];
                    }
                }else{
                    [self setResult:false msg:@"服务器返回错误，未获取到json对象"];
                }
                
            }];
            
        } else{
            [self setResult:false msg:@"服务器返回错误"];
        }
    }];
}

- (void)managerDidRecvPayResponse:(PayResp *)response{
    switch (response.errCode) {
        case WXSuccess:
            NSLog(@"支付成功－PaySuccess，retcode = %d", response.errCode);
            [self setResult:true msg:@"支付成功"];
            break;
            
        case -2:
            NSLog(@"支付成功－PayCancel，retcode = %d", response.errCode);
            [self setResult:false msg:@"您已取消支付"];
            break;
            
        default:
            NSLog(@"错误，retcode = %d, retstr = %@", response.errCode,response.errStr);
            [self setResult:false msg:response.errStr];
            break;
    }
}

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    switch (response.errCode) {
        case WXSuccess:
            NSLog(@"分享成功，retcode = %d", response.errCode);
            [self setResult:true msg:@"分享成功"];
            break;
            
        default:
            NSLog(@"错误，retcode = %d, retstr = %@", response.errCode,response.errStr);
            [self setResult:false msg: [NSString stringWithFormat: @"%@", response.errStr]];
            break;
    }
}

//客户端提示信息
- (void)setResult:(BOOL) success msg:(NSString *)msg
{
    [_hybridView callback:callback params:@{
                                            @"success": [NSNumber numberWithBool:success],
                                            @"msg": msg==NULL?@"":msg
                                            }];
}

@end