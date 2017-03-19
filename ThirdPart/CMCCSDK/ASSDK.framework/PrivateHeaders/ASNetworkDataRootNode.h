//
//  ASNetworkDataRootNode.h
//  CaiYun
//
//  Created by penghanbin on 13-1-7.
//
//

#import "ASNetworkDataModel.h"
#import "ASNetworkError.h"

@interface ASNetworkDataRootNode : ASNetworkDataModel

@property (nonatomic,strong) NSString *id_;
@property (nonatomic,strong) NSString *jsonrpc;
@property (nonatomic,strong) ASNetworkError *error;

@end
