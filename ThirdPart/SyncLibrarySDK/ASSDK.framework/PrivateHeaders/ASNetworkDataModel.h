//
//  ASNetworkDataModel
//  CaiYun
//
//  Created by penghanbin on 13-1-7.
//
//

#import <Foundation/Foundation.h>

@interface ASNetworkDataModel : NSObject

+ (NSArray *)objectsWithJsonArray:(NSArray *)jsonDics;

+ (instancetype)objectWithJsonDic:(NSDictionary *)jsonDic;

- (void)parse:(NSDictionary*)json ;
@end
