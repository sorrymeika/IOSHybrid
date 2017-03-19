/*
 
 压缩和解压缩函数
 
 数据压缩参考：
 
 http://www.clintharris.net/2009/how-to-gzip-data-in-memory-using-objective-c/
 
 数据解压缩参考：
 
 ASIHttpRequest库的文件：ASIDataDecompressor.m
 
 */

#import <Foundation/Foundation.h>

@interface ASGzipUtility : NSObject

+ (NSData*)as_gzipData:(NSData*)pUncompressedData;  //压缩
+ (NSData*)as_ungzipData:(NSData *)compressedData;  //解压缩

@end
