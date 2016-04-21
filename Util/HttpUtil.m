//
//  NSObject+ViewUtil.m
//  Letsgo
//
//  Created by 孙路 on 15/8/13.
//  Copyright (c) 2015年 Miku. All rights reserved.
//

#import "HttpUtil.h"

@implementation HttpUtil : NSObject


+ (UIImage *) getImage:(NSString *)src {

    NSURL *url = [NSURL URLWithString:src];
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
}


//上传
+ (void)post:(NSString *)url data:(NSDictionary *)data files:(NSDictionary *)files completion:(void (^)(NSString *results))completion
{
    
    //NSLog(path);
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    
    if (data!=nil)
    {
        //参数的集合的所有key的集合
        NSArray *keys= [data allKeys];
        
        //遍历keys
        for(int i=0;i<[keys count];i++)
        {
            //得到当前key
            NSString *key=[keys objectAtIndex:i];
            //NSLog(@"%@:%@",key,[params objectForKey:key]);
            
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[data objectForKey:key]];
        }
    }
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    if (files!=nil)
    {
        NSArray *keys= [files allKeys];
        //遍历keys
        for(int i=0;i<[keys count];i++)
        {
            //得到当前key
            NSString *key=[keys objectAtIndex:i];
            NSString *path=[files objectForKey:key];
            
            ////添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //声明pic字段，文件名为boris.png
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",key,path];
            //声明上传文件的格式
            [body appendFormat:@"Content-Type: application/octet-stream\r\n\r\n"];
            
        }
        //将body字符串转化为UTF8格式的二进制
        [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        
        for(int i=0;i<[keys count];i++)
        {
            //得到当前key
            NSString *key=[keys objectAtIndex:i];
            NSString *path=[files objectForKey:key];
            
            //将文件的data加入
            NSData *buffer=[NSData dataWithContentsOfFile:path];
            //NSData *data=[path dataUsingEncoding:NSUTF8StringEncoding];
            //NSLog(@"%d",data.length);
            
            [myRequestData appendData:buffer];
        }
    }
    else
    {
        [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //设置HTTPHeader中Content-Type的值
    if (data!=nil||files!=nil)
    {
        //声明结束符：--AaB03x--
        NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
        //加入结束符--AaB03x--
        [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
        //设置HTTPHeader
        [request setValue:content forHTTPHeaderField:@"Content-Type"];
    }
    
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSString *returnString;
        if (connectionError == nil) {
            // 网络请求结束之后执行!
            // 将Data转换成字符串
            returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
        }   else{
            returnString=nil;
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completion(returnString);
        }];
    }];
    
}

-(void)sendDeviceTokenWidthOldDeviceToken:(NSData *)oldToken newDeviceToken:(NSData *)newToken{
    //注意一定确保真机可以正常访问下面的地址
    NSString *urlStr=@"http://m.abs.cn:7788/json/juice/RegisterDeviceToken";
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10.0];
    [requestM setHTTPMethod:@"POST"];
    NSString *bodyStr=[NSString stringWithFormat:@"oldToken=%@&newToken=%@",oldToken,newToken];
    NSData *body=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [requestM setHTTPBody:body];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask= [session dataTaskWithRequest:requestM completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Send failure,error is :%@",error.localizedDescription);
        }else{
            NSLog(@"Send Success!");
        }
        
    }];
    [dataTask resume];
}

@end
