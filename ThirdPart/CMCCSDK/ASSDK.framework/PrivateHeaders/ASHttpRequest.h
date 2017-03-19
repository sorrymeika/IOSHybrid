//
//  ASHttpRequest.h
//  iContact
//
//  Created by kewenya on 12-4-17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASHttpRequest;

@protocol ASHttpRequestDelegate <NSObject>

- (void)httpRequestFail:(NetErrorCode)httpError;
- (void)httpRequestFinish:(NSData *)receiveData;

@optional

- (void)httpRequestWithFlowCost:(NSUInteger)bytes;
- (void)httpRequest:(ASHttpRequest *)request uploadProgress:(double)progress;

@end

#define kHttpFailedRetryDelay 5.0f

@interface ASHttpRequest : NSMutableURLRequest

@property (nonatomic,weak)id<ASHttpRequestDelegate> delegate;
@property (nonatomic,strong)NSString *alertViewStr;
@property (nonatomic,strong)NSString *alertViewCancelStr;
@property (nonatomic,strong)NSString *alertViewOtherStr;

@property (assign, readonly, nonatomic) NSTimeInterval retryDelay; // defualt value is kHttpFailedRetryDelay(5.0f)
@property (assign, readonly, nonatomic) NSInteger retryTimes; // defualt value is 1

/**
 *  是否需要续传

 通过 通知 来控制是否要续传
 kNtfHttpRequestFailWithTriedConnectionFinished 表示三次重连结束仍连接失败，由 网络层 post，外部 进行监听
 kNtfHttpRequestShouldResync 表示需要续传，由外部 post，在 ASHttpRequest 进行监听
 */
@property (nonatomic, assign) BOOL shouldResumeConnection;

- (void)startWithDelegate:(id<ASHttpRequestDelegate>)delegate;

//设置重试最大次数
- (void)setTryMax:(int)count __deprecated;

/**
 *  set retry times and delay
 *
 *  @param retryTimes retry times
 *  @param retryDelay retry delay
 */
- (void)setRetryTimes:(NSInteger)retryTimes retryDelay:(NSTimeInterval)retryDelay;

- (void)setTryAgainAlertView:(NSString*)str cancelButtonTitle:(NSString*)str1 otherButtonTitles:(NSString*)str2;

//流量计数
- (NSUInteger) getflowCount;

- (void)cancellWithSelector:(SEL)selector target:(id)target;

/**
 *  cancel the network (the delegate will be set to nil, so when restart, reset the delegate)
 */
- (void)cancel;

- (void)compressAndReceiveUncompressed;

@end
