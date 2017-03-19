//
//  NSObject+ViewUtil.h
//  Letsgo
//
//  Created by 孙路 on 15/8/13.
//  Copyright (c) 2015年 Miku. All rights reserved.
//

#import <Photos/Photos.h>

@interface AssetsUtil : NSObject{
}

+(AssetsUtil*) getInstance;

- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

// 获得所有的自定义相簿
- (PHFetchResult<PHAssetCollection *> *) albums;

// 获得相机胶卷
-(PHAssetCollection *)smartAlbum;

- (void) base64ThumbnailsInAlbum:(PHAssetCollection *)album page:(int) page pageSize:(int) pageSize size:(CGSize)size completion:(void (^)(NSMutableArray *, int, long)) completion;


- (NSString *)imageToBase64:(UIImage *)image;

- (void) originForAsset:(PHAsset *)asset completion:(void (^)(UIImage *, NSDictionary *))completion;


- (void) thumbnailForAsset:(PHAsset *)asset size:(CGSize)size completion:(void (^)(UIImage *, NSDictionary *, NSString *))completion;

@end
