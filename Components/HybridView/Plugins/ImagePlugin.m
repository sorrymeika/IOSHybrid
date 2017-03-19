//
//  JavaScriptAlert.m
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//
#import "ImagePlugin.h"
#import "StringUtil.h"
#import "AssetsUtil.h"
#import "FileUtil.h"
#import "HttpUtil.h"

@interface ImagePlugin ()<UIImagePickerControllerDelegate>{
    NSString *_callbackJsFn;
    NSMutableArray *allImages;
}
@end

@implementation ImagePlugin


-(void)execute:(NSDictionary *)command{
    NSString * callback=[command objectForKey:@"callback"];
    NSDictionary *params = [command objectForKey:@"params"];
    
    NSString * type=[params objectForKey:@"type"];
    
    bool allowsEditing =[[params objectForKey:@"allowsEditing"] boolValue];
    
    NSLog(@"%d",allowsEditing);
    
    _callbackJsFn=callback;
    
    if ([type isEqualToString:@"camera"]){
        //判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            // 跳转到相机
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            imagePickerController.allowsEditing = allowsEditing;
            
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [_hybridView.viewController presentViewController:imagePickerController animated:YES completion:^{}];
            
        }
        else
        {
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:nil message:@"相机不能用" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alertView show];
        }
        
    } else if ([type isEqualToString:@"photo"]){
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = allowsEditing;
        
        // 跳转到图库
        //imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        // 跳转到相册
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [_hybridView.viewController presentViewController:imagePickerController animated:YES completion:^{}];
        
        
    } else if ([type isEqualToString:@"upload"]) {
        
        NSString *url = params[@"url"];
        
        NSArray *imgs = params[@"images"];
        
        NSDictionary *data = params[@"data"];
        
        NSMutableDictionary *files = [NSMutableDictionary dictionaryWithCapacity:imgs.count];
        
        UIImage *img;
        
        for (NSDictionary *imageInfo in imgs) {
            
            img = [allImages objectAtIndex: [imageInfo[@"value"] longValue]];
            
            [files setObject:UIImageJPEGRepresentation(img, 0.5f) forKey: imageInfo[@"name"]];
        }
        
        [HttpUtil post:url data:data files:files completion:^(NSString *results) {
            
            NSLog(@"%@ ", results);
            
            [_hybridView callbackWithString:callback params:results];
        }];
        
        
        
    }
}


#pragma mark UIImagePickerControllerDelegate协议的方法
/* 此处info 有六个值
 * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
 * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
 * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
 * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
 * UIImagePickerControllerMediaURL;       // an NSURL
 * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
 * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    if (nil == allImages) {
        allImages = [NSMutableArray array];
    }
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage]?:[info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    /*
     NSString *assetPath;
     
     //实例化一个NSDateFormatter对象
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     //设定时间格式,这里可以设置成自己需要的格式yyyy-MM-dd HH:mm:ss
     [dateFormatter setDateFormat:@"yyMMddHHmmss_ffff"];
     //用[NSDate date]可以获取系统当前时间
     NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
     //输出格式为：2010-10-27 10:22:13
     NSLog(@"%@",currentDateStr);
     
     NSString *imageName = [NSString stringWithFormat:@"%@.jpg",currentDateStr];
     
     // 获取沙盒目录
     assetPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
     
     NSData *imageData = UIImageJPEGRepresentation(image, 0.6f);
     
     [imageData writeToFile:assetPath atomically:NO];
     
     */
    
    AssetsUtil *assetsUtil = [AssetsUtil getInstance];
    
    NSLog(@"w:%f,h:%f",image.size.width,image.size.height);
    
    UIImage *thumbnail = [assetsUtil thumbnailWithImageWithoutScale:image size:CGSizeMake(140.0f, 140.0f)];
    
    NSString *imageBase64Str = [assetsUtil imageToBase64:thumbnail];
    
    long imageId = [allImages count];
    
    [allImages addObject:image];
    
    NSDictionary *result=@{
                           @"id": [NSNumber numberWithLong: imageId],
                           @"thumbnail": imageBase64Str
                           //@"src": [assetsUtil imageToBase64:image]
                           };
    
    [_hybridView callback:_callbackJsFn params:result];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_hybridView.viewController dismissViewControllerAnimated:YES completion:^{}];
}

@end
