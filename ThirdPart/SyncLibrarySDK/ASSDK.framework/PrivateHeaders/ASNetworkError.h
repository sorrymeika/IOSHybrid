//
//  ASNetworkError.h
//  CaiYun
//
//  Created by penghanbin on 13-1-7.
//
//

#import "ASNetworkDataModel.h"

@interface ASNetworkError : ASNetworkDataModel
@property (nonatomic,strong) NSString *message;
@property (nonatomic,assign) NSInteger code;

+ (ASNetworkError *)errorWithCode:(NSInteger)code message:(NSString *)message;

@end
