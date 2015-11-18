//
//  NSObject+ViewUtil.m
//  Letsgo
//
//  Created by 孙路 on 15/8/13.
//  Copyright (c) 2015年 Miku. All rights reserved.
//

#import "FileUtil.h"

@implementation FileUtil : NSObject


+(NSString*) getFullName:(NSString *)fileName{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:fileName];
    return finalPath;
}

+(NSData*) pathToData:(NSString *)fileName{
    NSData *imageData = [NSData dataWithContentsOfFile: [FileUtil getFullName:fileName]];
    return imageData;
    
}

+(UIImage*) pathToImage:(NSString *)fileName{
    UIImage *image = [UIImage imageWithData: [FileUtil pathToData:fileName]];
    return image;
}

@end
