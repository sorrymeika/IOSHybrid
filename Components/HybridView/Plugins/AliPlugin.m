//
//  JavaScriptAlert.m
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//
#import "AliPlugin.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "Order.h"

@interface AliPlugin (){
    NSString *callback;
}
@end

@implementation AliPlugin


-(void)execute:(NSDictionary *)command{
    callback=[command objectForKey:@"callback"];
    
    NSDictionary *params = [command objectForKey:@"params"];
    
    NSString * type=[params objectForKey:@"type"];
    
    if ([type isEqualToString:@"pay"]){
        
        NSString * spUrl=[params objectForKey:@"spUrl"];
        NSString * orderCode=[params objectForKey:@"orderCode"];
    
        [self sendPay:spUrl orderCode:orderCode];
        //[self test];
    }
}

- (void)sendPay:(NSString *)spUrl orderCode:(NSString *)orderCode
{
    //根据服务器端编码确定是否转码
    NSStringEncoding enc;
    //if UTF8编码
    enc = NSUTF8StringEncoding;
    //if GBK编码
    //enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *urlString = [NSString stringWithFormat:@"%@?plat=ios&order_no=%@",
                           spUrl,
                           [orderCode stringByAddingPercentEscapesUsingEncoding:enc]];
    
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
                        NSString *orderSpec  = [dict objectForKey:@"orderSpec"];
                        NSString *signedString  = [dict objectForKey:@"signedString"];
                        
                        NSLog(@"signedString = %@",signedString);
                        
                        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                       orderSpec, signedString, @"RSA"];
                        
                        NSLog(@"orderSpec = %@",orderSpec);
                        
                        NSLog(@"orderString = %@",orderString);
                        
                        [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"abschinapp" callback:^(NSDictionary *resultDic) {
                            NSLog(@"reslut = %@",resultDic);
                        }];
                        
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


//客户端提示信息
- (void)setResult:(BOOL) success msg:(NSString *)msg
{
    [_hybridView callback:callback params:@{
                                            @"success": [NSNumber numberWithBool:success],
                                            @"msg": msg==NULL?@"":msg
                                            }];
}




- (void)test{
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"";
    NSString *seller = @"";
    NSString *privateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = @"800220160115378029"; //订单ID（由商家自行制定）
    order.productName = @"爱彼此家居商品:800220160115378029"; //商品标题
    order.productDescription = @"爱彼此家居商品:800220160115378029"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",299.0]; //商品价格
    order.notifyURL =  @"http://appuser2.abs.cn/AlipayApp/Notify"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"http://m.abs.cn";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"abschinapp";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        NSLog(@"orderString = %@",orderString);

        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}



@end