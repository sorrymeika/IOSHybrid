//
//  NSObject+ViewUtil.m
//
//  Created by 孙路 on 15/8/13.
//  Copyright (c) 2015年 Miku. All rights reserved.
//

#import "AssetsUtil.h"

#import <Photos/Photos.h>

static AssetsUtil * assetsUtilInstance = nil;

@implementation AssetsUtil : NSObject

+(AssetsUtil *)getInstance
{
    @synchronized(self) {
        if (assetsUtilInstance == nil)
            assetsUtilInstance = [[self alloc] init];
    }
    
    return assetsUtilInstance;
}

// 获得相机胶卷
-(PHAssetCollection *)smartAlbum {
    
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    
    return cameraRoll;
}

// 获得所有的自定义相簿
- (PHFetchResult<PHAssetCollection *> *) albums {
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    
    return assetCollections;
}

- (void) base64ThumbnailsInAlbum:(PHAssetCollection *)album page:(int) page pageSize:(int) pageSize size:(CGSize)size completion:(void (^)(NSMutableArray *, int, long)) completion {
    
    NSMutableArray *images =[NSMutableArray array];
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:album options:nil];
    
    NSUInteger assetsCount = [assets count];
    
    int left = assetsCount % pageSize;
    int totalPages = (int)((assetsCount - (long)left) / pageSize + (left==0?0:1));
    
    
    if (page > totalPages) {
        page = totalPages;
    }
    
    if (page == totalPages && left != 0) {
        pageSize = left;
    }
    
    NSLog(@"aaa:%d,%d,%d",page,totalPages,pageSize);
    
    __block NSUInteger count = pageSize;
    
    for (NSUInteger i = assetsCount - page * pageSize; i < assetsCount - (page - 1) * pageSize; i++) {
        
        PHAsset *asset = [assets objectAtIndex:i];
        
        [self thumbnailForAsset:asset size:size completion:^(UIImage *result, NSDictionary *info,NSString *assetId) {
            count = count-1;
            
            [images addObject:@{
                                @"index": [NSNumber numberWithLong:i],
                                @"id": assetId,
                                @"src":[self imageToBase64: [self thumbnailWithImageWithoutScale:result size:size]]
                                }];
            
            if (count <= 0) {
                completion(images, totalPages, assetsCount);
            }
            
        }];
        
    }
}



- (void) originForAsset:(PHAsset *)asset completion:(void (^)(UIImage *, NSDictionary *))completion{
    
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    // 是否要原图
    CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    
    // 从asset中获得图片
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        // 排除取消，错误，低清图三种情况
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        
        //NSLog(@"%@", result);
        
        if (downloadFinined) {
            completion(result,info);
        }
    }];
    
}

- (void) thumbnailForAsset:(PHAsset *)asset size:(CGSize)size completion:(void (^)(UIImage *, NSDictionary *, NSString *))completion{
    
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(size.width * screenScale, size.height * screenScale) contentMode:PHImageContentModeAspectFill options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        
        // 排除取消，错误，低清图三种情况
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        
        //NSLog(@"%@%@%d%@", result,info,downloadFinined,asset.localIdentifier);
        
        if (downloadFinined) {
            
            completion(result, info, asset.localIdentifier);
        }
    }];
    
}

- (NSString *)imageToBase64:(UIImage *)image {
    
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
    
    NSString *imageBase64Str =[NSString stringWithFormat:@"data:image/jpeg;base64,%@",[imageData base64Encoding]];
    
    return imageBase64Str;
}


- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
        
    } else{
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y = 0;
            
        } else{
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    
    return newimage;
}

@end
