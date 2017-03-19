//
//  JavaScriptAlert.m
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//
#import "CMCCPlugin.h"
#import "KeyChainUtil.h"
#import "StringUtil.h"
#import "sys/utsname.h"

#import "IDMPTempSmsMode.h"
#import "IDMPAutoLoginViewController.h"

#import <ASSDK/ASSDK.h>

// #import "IDMPToken.h"

@interface CMCCPlugin ()<ASOnLineContactsEngineDelegate,ASSyncNetworkEngineDelegate> {
    IDMPAutoLoginViewController *_autoLogin;
    ASOnLineContactsEngine *onlineEngine;
    
    ASUploadContactEngine *uploadEngine;
    
    UIAlertView* alert;
    
    BOOL isSessionAuthSuccess;
    
}
@end

@implementation CMCCPlugin

NSString * const ASSyncingContactTip = @"正在处理联系人数据\n请稍候...";
NSString * const ASAutoSyncingTip = @"自动同步状态，无需手动上传下载";
NSString * const ASSessionOutTimeTip = @"Session过期，请使用有效的Session";


-(void)execute:(NSDictionary *)command{
    NSString * callback=[command objectForKey:@"callback"];
    
    
    NSDictionary *params = [command objectForKey:@"params"];
    
    NSString * type = [params objectForKey:@"type"];
    
    if ([type isEqualToString:@"sendSms"]){
        
        
        NSString *busiType = @"1";
        NSString *bizType = [params objectForKey:@"bizType"];
        NSString *phoneNo = [params objectForKey:@"phoneNo"];
        
        if ([bizType isEqualToString:@"register"]) {
            
            busiType = @"1";
        } else if ([bizType isEqualToString:@"resetPwd"]) {
            
            busiType = @"2";
        } else if ([bizType isEqualToString:@"smsLogin"]) {
            
            busiType = @"3";
        }
        
        IDMPTempSmsMode *smsModel = [[IDMPTempSmsMode alloc]init];
        IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc] init];
        
        [autoLogin validateWithAppid:@"02800151" appkey:@"A65B80C21C55E2AE" timeoutInterval:18.6 finishBlock:^(NSDictionary *paraments) {
            NSLog(@"成功:%@",paraments);
            [smsModel getSmsCodeWithUserName:phoneNo busiType:busiType successBlock:^(NSDictionary *paraments) {
                NSLog(@"get sms success");
                NSLog(@"%@",paraments);
                
                if (callback) {
                    
                    [_hybridView callback:callback params:@{
                                                            @"success": [NSNumber numberWithBool:true]
                                                            }];
                }
                
            } failBlock:^(NSDictionary *paraments) {
                
                NSLog(@"get sms fail");
                NSLog(@"%@",paraments);
                
                [_hybridView callback:callback params:@{
                                                        @"success": [NSNumber numberWithBool:false]
                                                        }];
            }];
            
            
        } failBlock:^(NSDictionary *paraments) {
            NSLog(@"失败:%@",paraments);
        }];
        
    } else if ([type isEqualToString:@"login"]) {
        
        
        NSString *password = [params objectForKey:@"password"];
        NSString *phoneNo = [params objectForKey:@"phoneNo"];
        NSString *loginType = [params objectForKey:@"loginType"];
        
        
        short authnType;
        if ([loginType isEqualToString:@"sms"]) {
            authnType = 3;
            
        } else {
            
            authnType = 2;
        }
        
        
        [self getIDMPAutoLogin:^(IDMPAutoLoginViewController *autoLogin) {
            
            [autoLogin getAccessTokenByConditionWithUserName:phoneNo Content:password andLoginType:authnType finishBlock:^(NSDictionary *paraments) {
                
                NSLog(@"%@",paraments);
                NSString *tokenStr = [paraments objectForKey:@"token"];
                
                [_hybridView callback:callback params:@{
                                                        @"success": [NSNumber numberWithBool:true],
                                                        @"token": tokenStr
                                                        }];
                
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"%@",paraments);
                
                [_hybridView callback:callback params:@{
                                                        @"success": [NSNumber numberWithBool:false],
                                                        @"message": @"用户名或密码错误"
                                                        }];
            }];
            
            
        } failBlock:^(NSDictionary *paraments) { }];
        
        
        
        
        // [autoLogin getAccessTokenByConditionWithUserName:];
        
        
    } else if ([@"contactCount" isEqualToString:type]) {
        
        [_hybridView callback:callback params:@{
                                                @"success": [NSNumber numberWithBool:true],
                                                @"locCount": [NSNumber numberWithUnsignedInteger:[self getLocalContactsCount]]
                                                }];
    }
    
}


-(void)getIDMPAutoLogin:(void (^)(IDMPAutoLoginViewController *))finishBlock failBlock:(void (^)(NSDictionary *))failBlock {
    
    if (!_autoLogin) {
        
        _autoLogin=[[IDMPAutoLoginViewController alloc] init];
        
        [_autoLogin validateWithAppid:@"02800151" appkey:@"A65B80C21C55E2AE" timeoutInterval:18.6 finishBlock:^(NSDictionary *paraments) {
            NSLog(@"成功:%@",paraments);
            
            finishBlock(_autoLogin);
            
            
        } failBlock:^(NSDictionary *paraments) {
            NSLog(@"失败:%@",paraments);
            
            _autoLogin=nil;
            
            if (failBlock) failBlock(paraments);
        }];
        
    } else {
        finishBlock(_autoLogin);
    }
}

-(void)getToken:(NSString *)phoneNo finishBlock:(void (^)(NSString *))finishBlock failBlock:(void (^)(NSDictionary *))failBlock {
    
    [self getIDMPAutoLogin:^(IDMPAutoLoginViewController *autoLogin) {
        
        [autoLogin getAccessTokenWithUserName:phoneNo andLoginType:2 isUserDefaultUI:NO finishBlock:^(NSDictionary *paraments) {
            
            NSLog(@"%@",paraments);
            NSString *tokenStr = [paraments objectForKey:@"token"];
            
            finishBlock(tokenStr);
            
        } failBlock:failBlock];
        
        
    } failBlock:failBlock];
}


-(void)getContactSession{
    
    if (!isSessionAuthSuccess) {
        [self showWarningAlertViewWithMessage:ASSessionOutTimeTip];
        return;
    }
    
    
    isSessionAuthSuccess=YES;
}



- (void)showWarningAlertViewWithMessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:@"温馨提醒"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void) dismissProcessText {
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    alert=nil;
}

- (void)showProgressText:(NSString*)text
{
    [alert setMessage:text];
}

- (void)showSyncingContactsTip
{
    [self showWarningAlertViewWithMessage:ASSyncingContactTip];
}


- (void)uploadContact
{
    if (!uploadEngine) {
        uploadEngine=[[ASUploadContactEngine alloc] init];
        uploadEngine.delegate = self;
    }
    
    if ([uploadEngine start])
    {
        // self.curSync = self.uploadEngine;
        
        
        alert = [[UIAlertView alloc] initWithTitle:@"备份中"
                                           message:@"正在备份..."
                                          delegate:nil
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
        
        [alert show];
    }
    else
    {
        [self showSyncingContactsTip];
    }
}

- (void)getOnlineContactNum
{
    if (!onlineEngine)
    {
        onlineEngine=[[ASOnLineContactsEngine alloc] init];
    }
    
    onlineEngine.delegate=self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [onlineEngine start];
    });
}


#pragma mark - OnLineContactsEngineDelegate

- (void)contactCountSuccess:(NSString*)contactsCount
{
    DLog(@"contactsCount %@",contactsCount);
}

- (void)contactCountFail:(NetErrorCode)errorCode withStr:(NSString*)str
{
    DLog(@"contactCountFail:%ld %@",(long)errorCode,str);
}


- (NSUInteger) getLocalContactsCount
{
    NSUInteger count = [ASSyncLibraryManager contactsCountForRealtime:nil];
    
    NSLog(@"本地联系人数量：%ld", (long)count);
    
    return count;
    
}


#pragma mark - SyncNetworkEngineDelegate

- (void) syncContactSuccessAlert:(NSString *)text {
    
    [self dismissProcessText];
    
    [[[UIAlertView alloc] initWithTitle:@"备份成功"
                                message:text
                               delegate:nil
                      cancelButtonTitle:@"好"
                      otherButtonTitles:nil] show];
}

- (void) syncContactFailAlert:(NSString *)text {
    
    [self dismissProcessText];
    
    [[[UIAlertView alloc] initWithTitle:@"备份失败"
                                message:text
                               delegate:nil
                      cancelButtonTitle:@"好"
                      otherButtonTitles:nil] show];
}

- (void)syncContactSuccess:(ASSyncNetworkEngine *)syncEngine
{
    ASSyncResult *syncResult = syncEngine.syncResult;
    NSString *text = [NSString stringWithFormat:@"服务器\n新增:%ld 修改:%ld 删除:%ld\n\n本地\n新增:%ld 修改:%ld 删除:%ld\n", (long)syncResult.serverAddIds, (long)syncResult.serverUpdateIds, (long)syncResult.serverDeleteIds, (long)syncResult.addlocal, (long)syncResult.replacelocal, (long)syncResult.deletelocal];
    
    [self performSelectorOnMainThread:@selector(syncContactSuccessAlert:) withObject:text waitUntilDone:NO];
    
    //[alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)syncContactFail:(ASSyncNetworkEngine *)syncEngine errorCode:(NetErrorCode)errorCode errorMsg:(NSString*)errorMsg
{
    [self showWarningAlertViewWithMessage:errorMsg];
    [self performSelectorOnMainThread:@selector(syncContactFailAlert:) withObject:errorMsg waitUntilDone:NO];
    
    DLog(@"syncContactFail:%ld %@", (long)errorCode, errorMsg);
    
}

- (void)syncNetworkEngine:(ASSyncNetworkEngine *)syncEngine progress:(float)newProgress
{
    // [self performSelectorOnMainThread:@selector(showProgress:) withObject:[NSNumber numberWithFloat:newProgress] waitUntilDone:NO];
    
    DLog(@"synProgress:%f",newProgress);
}

- (void)syncNetworkEngine:(ASSyncNetworkEngine *)syncEngine progressText:(NSString *)text
{
    [self performSelectorOnMainThread:@selector(showProgressText:) withObject:text waitUntilDone:NO];
    
    DLog(@"synProgressText:%@",text);
}

- (void)syncNetworkEngine:(ASSyncNetworkEngine *)syncEngine uploadProgress:(double)progress
{
    DLog(@"%f", progress);
}

- (void)syncContactDidCanceled:(ASSyncNetworkEngine *)syncEngine withObject:(id)canceledObject
{
    ASSyncNetworkEngine *syncNetworkEngine = [ASSyncNetworkEngine runningSyncNetworkEngine];
    if (syncNetworkEngine)
    {
        [self showWarningAlertViewWithMessage:@"同步取消成功"];
    }
}




@end
