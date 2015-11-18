//
//  ViewController.m
//  Abs
//
//  Created by Miku on 13-10-7.
//  Copyright (c) 2013年 Miku. All rights reserved.
//

#import "CPHybridViewController.h"
#import "UIHybridView.h"
#import "ViewUtil.h"
#import "StringUtil.h"
#import "HttpUtil.h"
#import "CPModalWebViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface CPHybridViewController ()<CLLocationManagerDelegate>{
    
    CLLocationManager *_locationManager;
    NSString *_locationGettingCallback;
    NSString *_mainUrlString;
}
@end

@implementation CPHybridViewController


- (instancetype)initWithAddress:(NSString*)urlString {
    _mainUrlString=urlString;
    return self;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


- (void) webViewDidFinishLoad: (UIWebView *) webView
{
    // trigger an alert.  for demonstration only:
    
}

- (BOOL)canBecomeFirstResponder
{
    return YES;// default is NO
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    
    
    hybridView = [[UIHybridView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:hybridView];
    [hybridView setBackgroundColor:[UIColor clearColor]];
    hybridView.scalesPageToFit =YES;
    hybridView.delegate = self;
    hybridView.hybridDelegate=self;
    hybridView.scrollView.delegate = self;
    
    NSLog(@"width %f",[[UIScreen mainScreen] bounds].size.width);
    
    //禁用UIWebView拖拽
    [(UIScrollView *)[[hybridView subviews] objectAtIndex:0] setBounces:NO];
    [(UIScrollView *)[[hybridView subviews] objectAtIndex:0] setShowsVerticalScrollIndicator:NO];
    
    [hybridView loadRequestWidthAddress:!_mainUrlString? @"index.html":_mainUrlString];
    
    //[ViewUtil loadDocument:hybridView url:@"http://192.168.10.129:5559/"];
    //[ViewUtil loadDocument:hybridView url:@"http://192.168.0.104:5559/"];
}



- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView{ // 实现代理方法， step 3
    return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //这里得到了键盘的frame
    CGRect keyboardRect = [value CGRectValue];
    
    NSLog(@"height:%f",keyboardRect.size.height);
    
    CGRect origionRect = hybridView.frame;
    CGRect newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, origionRect.size.width, [[UIScreen mainScreen] bounds].size.height-keyboardRect.size.height);
    hybridView.frame = newRect;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    // 获取info同上面的方法
    // 你的操作，如键盘移除，控制视图还原等
    hybridView.frame = [[UIScreen mainScreen] bounds];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


- (void)callNativeApi:(UIHybridView*)webView command:(NSDictionary *)command {
    //NSLog(@"json %@", json);
    //json=[self decodeUrl:json];
    //json=[json stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSError *error = nil;
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    //NSDictionary *info = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    
    NSString *method = [command objectForKey:@"method"];
    NSString *callback = [command objectForKey:@"callback"];
    
    //NSLog(@"method %@", method);
    if ([method isEqualToString:@"share"]) {
        
    } else if  ([method isEqualToString:@"open"]) {
        NSString *params=[command objectForKey:@"params"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:params]];
        
    } else if  ([method isEqualToString:@"openInApp"]) {
        NSString *params=[command objectForKey:@"params"];
        
        CPModalWebViewController *webC = [[CPModalWebViewController alloc] initWithAddress:params];
        
        [self presentViewController:webC animated:YES completion:^{}];
        
    } else if ([method isEqualToString:@"getDeviceToken"]){
        NSString *key=@"DeviceToken";
        NSData *token= [[NSUserDefaults standardUserDefaults]objectForKey:key];
        
        NSString *params=@"";
        if (token) {
            params=[@"" stringByAppendingFormat:@"'%@'",token];
        }
        
        [self hybridCallback:callback params:params];
        
    } else if ([method isEqualToString:@"takePhoto"]) {
        self.pickImageCallback=callback;
        
        //判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            // 跳转到相机或相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            
            //[imagePickerController release];
        }
        else
        {
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:nil message:@"相机不能用" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alertView show];
            //[alertView release];
        }
        
    } else if ([method isEqualToString:@"pickImage"]) {
        self.pickImageCallback=callback;
        
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
        //[imagePickerController release];
        
        
    }  else if ([method isEqualToString:@"post"]) {
        
        //[self hybridCallback:callback params:@"\"success-1\""];
        NSDictionary *params=[command objectForKey:@"params"];
        NSString *url=[params objectForKey:@"url"];
        NSDictionary *data=[params objectForKey:@"data"];
        NSDictionary *files=[params objectForKey:@"files"];
        
        NSLog(@"start upload %@",url);
        
        [HttpUtil post:url data:data files:files completion:^(NSString *result){
            [self hybridCallback:callback params:result];
        }];
        
    } else if ([method isEqualToString:@"login"]) {
        
        
    } else if ([method isEqualToString:@"getRect"]) {
        CGRect rect = [webView frame];
        [self hybridCallback:callback params:[@"" stringByAppendingFormat:@"%f,%f",rect.size.width,rect.size.height]];
        
    } else if ([method isEqualToString:@"onload"]||[@"queryThumbnailList" isEqualToString:method]) {
        
    } else {
        //[webView stringByEvaluatingJavaScriptFromString:[@"alert(\"" stringByAppendingFormat:@"%@\")", method]];
    }
}

-(void)hybridCallback:(NSString *)callback params:(NSString *)params
{
    //NSDictionary *registerDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:3],@"_id",@"test",@"login_name",@"123456",@"password",nil];
    
    NSLog(@"window.hybridFunctions.%@(%@);",callback,params);
    
    [hybridView stringByEvaluatingJavaScriptFromString:[@"window.hybridFunctions." stringByAppendingFormat:@"%@(%@);",callback,params]];
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
    
    [self hybridCallback:self.pickImageCallback params:[StringUtil stringify:result]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
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



- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"开始摇动手机");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"stop");
    [hybridView stringByEvaluatingJavaScriptFromString:@"app_trigger(\"motion\")"];
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"取消");
}


@end
