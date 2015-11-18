//
//  NSObject+ViewUtil.h
//  Letsgo
//
//  Created by 孙路 on 15/8/13.
//  Copyright (c) 2015年 Miku. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface FileUtil : NSObject{
}
+(NSString*) getFullName:(NSString *)fileName;

+(NSData*) pathToData:(NSString *)fileName;

+(UIImage*) pathToImage:(NSObject *)fileName;

@end
