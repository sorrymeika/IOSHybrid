//
//  JavaScriptAlert.m
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//
#import "ImagePlugin.h"
#import "StringUtil.h"

@interface ImagePlugin ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    NSString *_callbackJsFn;
}
@end

@implementation ImagePlugin


-(void)execute:(NSDictionary *)command{
    NSString * callback=[command objectForKey:@"callback"];
    NSDictionary *params = [command objectForKey:@"params"];
    
    NSString * type=[params objectForKey:@"type"];
    
    _callbackJsFn=callback;
    
    if ([type isEqualToString:@"camera"]){
        //判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            // 跳转到相机或相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [_hybridView.viewController presentViewController:imagePickerController animated:YES completion:^{}];
            
        }
        else
        {
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:nil message:@"相机不能用" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alertView show];
            //[alertView release];
        }
        
    } else {
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [_hybridView.viewController presentViewController:imagePickerController animated:YES completion:^{}];
    }
}



#pragma mark UIImagePickerControllerDelegate协议的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式yyyy-MM-dd HH:mm:ss
    [dateFormatter setDateFormat:@"yyMMddHHmmss_ffff"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //输出格式为：2010-10-27 10:22:13
    NSLog(@"%@",currentDateStr);
    //alloc后对不使用的对象别忘了release
    //[dateFormatter release];
    
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",currentDateStr];
    
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6f);
    
    [imageData writeToFile:fullPath atomically:NO];
    
    UIImage *thumbnail=[self thumbnailWithImageWithoutScale:image size:CGSizeMake(140.0f, 140.0f)];
    imageData = UIImageJPEGRepresentation(thumbnail, 0.6f);
    
    NSString *imageBase64Str =[NSString stringWithFormat:@"data:image/jpeg;base64,%@",[imageData base64Encoding]];
    NSDictionary *result=[NSDictionary dictionaryWithObjectsAndKeys:fullPath,@"path",imageBase64Str,@"src",nil];
    
    [_hybridView callback:_callbackJsFn params:result];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_hybridView.viewController dismissViewControllerAnimated:YES completion:^{}];
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