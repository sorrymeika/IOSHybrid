//
//  JavaScriptAlert.m
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//
#import "AssetsPlugin.h"
#import "KeyChainUtil.h"
#import "AssetsUtil.h"
#import <Photos/Photos.h>

@interface AssetsPlugin (){
    PHFetchResult<PHAssetCollection *> *albums;
}
@end

@implementation AssetsPlugin

-(PHAssetCollection *)albumById:(NSString *)albumId{
    
    PHAssetCollection *album;
    AssetsUtil *assetsUtil = [AssetsUtil getInstance];
    
    PHAssetCollection *smartAlbum = [assetsUtil smartAlbum];
    
    if (albumId==nil||[@"" isEqualToString:albumId]||[albumId isEqualToString:smartAlbum.localIdentifier]) {
        album = smartAlbum;
        
    } else {
        
        if (albums==nil) {
            albums = [assetsUtil albums];
        }
        
        for (PHAssetCollection *assetCollection in albums) {
            
            if ([assetCollection.localIdentifier isEqualToString:albumId]) {
                album = assetCollection;
                break;
            }
            
        }
    }
    
    return album;
    
}


-(void)execute:(NSDictionary *)command{
    NSString * callback=[command objectForKey:@"callback"];
    
    
    NSDictionary *params = [command objectForKey:@"params"];
    
    NSString * type=[params objectForKey:@"type"];
    
    AssetsUtil *assetsUtil = [AssetsUtil getInstance];
    
    
    
    if ([type isEqualToString:@"album"]){
        
        albums = [assetsUtil albums];
        
        long albumsCount = [albums count];
        __block long count = albumsCount;
        
        NSMutableArray *results = [NSMutableArray array];
        
        
        void (^addAlbum)(NSString *,PHAssetCollection *,long) = ^(NSString *thumbnail,PHAssetCollection *album,long index) {
            count--;
            
            [results addObject: @{
                                  @"index": [NSNumber numberWithLong:index],
                                  @"thumbnail": thumbnail,
                                  @"count": [NSNumber numberWithUnsignedLong: albumsCount],
                                  @"albumId": album.localIdentifier,
                                  @"albumName":album.localizedTitle
                                  }];
            
            [results sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                
                NSNumber *a = [obj1 objectForKey:@"index"];
                NSNumber *b = [obj2 objectForKey:@"index"];
                
                return [a compare: b];
            }];
            
            if (count <= -1) {
                
                [_hybridView callback:callback params:@{
                                                        @"data": results
                                                        }];
            }
            
        };
        
        
        
        for (long i = -1;i < albumsCount;i++) {
            PHAssetCollection *assetCollection;
            if (i == -1) {
                assetCollection = [assetsUtil smartAlbum];
                
            } else {
                assetCollection = [albums objectAtIndex:i];
            }
            
            
            PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            
            long assetsCount = [assets count];
            
            if (assetsCount != 0) {
                
                PHAsset *asset = [assets objectAtIndex:0];
                
                [assetsUtil thumbnailForAsset:asset size:CGSizeMake(140, 140) completion:^(UIImage *image, NSDictionary *info, NSString *assetId) {
                    NSString *thumbnail = [assetsUtil imageToBase64:image];
                    
                    
                    addAlbum(thumbnail, assetCollection,i);
                    
                    
                }];
                
            } else {
                addAlbum(@"", assetCollection,i);
            }
            
        }
        
    } else if ([type isEqualToString:@"thumbnails"]) {
        
        NSString *albumId = [params objectForKey:@"albumId"];
        PHAssetCollection *album = [self albumById:albumId];
        
        int width  = [[params objectForKey:@"width"] intValue];
        int height  = [[params objectForKey:@"height"] intValue];
        
        int page  = [[params objectForKey:@"page"] intValue];
        int pageSize = [[params objectForKey:@"pageSize"] intValue];
        
        
        CGSize size;
        
        if (width == 0|| height == 0) {
            size = CGSizeMake(70, 70);
        } else {
            size = CGSizeMake((float)width, (float)height);
        }
        
        [assetsUtil base64ThumbnailsInAlbum:album page:page pageSize:pageSize size:size completion:^(NSMutableArray *images,int totalPages,long total) {
            
            [_hybridView callback:callback params:@{
                                                    @"albumId": album.localIdentifier,
                                                    @"totalPages": [NSNumber numberWithInt: totalPages],
                                                    @"total": [NSNumber numberWithLong: total],
                                                    @"data": images
                                                    }];
            
        }];
        
    } else if ([type isEqualToString:@"image"]) {
        
        NSString *albumId = [params objectForKey:@"albumId"];
        NSString *assetId = [params objectForKey:@"assetId"];
        
        if (nil == assetId) {
            return;
        }
        
        PHAssetCollection *album = [self albumById:albumId];
        
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:album options:nil];
        
        for (PHAsset *asset in assets) {
            
            if ([asset.localIdentifier isEqualToString:assetId]) {
                
                [assetsUtil originForAsset:asset completion:^(UIImage *image, NSDictionary *info) {
                    
                    [_hybridView callback:callback params:@{
                                                            @"assetId": assetId,
                                                            @"src": [assetsUtil imageToBase64:image]
                                                            }];
                    
                }];
                
                break;
                
            }
        }
        
        
    }
    
}


@end
