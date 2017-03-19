//
//  ASUIDeviceHardware.h
//  PXiPhone
//
//  Created by Tuitu_Zaza on 11-5-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ASUIDeviceHardware : NSObject 

+ (NSString *)platform;
+ (NSString *)platformString;
+ (NSString *)screenModel;
+ (NSString *)getMacAddress;
+ (NSString *)getDeviceUUID;


//生成通用唯一识别码
+ (NSString *)uuid ;

+ (BOOL)hasRetinaDisplay;


@end
