//
//  ViewController.m
//  Abs
//
//  Created by Miku on 13-10-7.
//  Copyright (c) 2013年 Miku. All rights reserved.
//

#import "ViewController.h"
#import "UIHybridView.h"
#import "ViewUtil.h"
#import "HttpUtil.h"
#import "CPModalWebViewController.h"
#import "BrowserPlugin.h"

//微信APP端相关头文件
#import "WXApi.h"
#import "payRequsestHandler.h"

#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>{
    
    CLLocationManager *_locationManager;
    NSString *_locationGettingCallback;
}
@end

@implementation ViewController

//- (void) loadView

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
    hybridView.viewController=self;
    
    hybridView.scrollView.delegate = self;
    
    NSLog(@"width %f",[[UIScreen mainScreen] bounds].size.width);
    
    //禁用UIWebView拖拽
    [(UIScrollView *)[[hybridView subviews] objectAtIndex:0] setBounces:NO];
    [(UIScrollView *)[[hybridView subviews] objectAtIndex:0] setShowsVerticalScrollIndicator:NO];
    
    //[ViewUtil loadDocument:hybridView url:@"http://www.baidu.com/"];
    [ViewUtil loadDocument:hybridView url:@"index.html"];
    //[ViewUtil loadDocument:hybridView url:@"http://192.168.0.104:5559/"];
}

-(void) startGettingLocation{
    //<--定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
    //定位管理器-->
}

#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
    
    [self hybridCallback:_locationGettingCallback params:[NSString stringWithFormat:@"%f,%f,%f,%f,%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed]];
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
    CGRect keyboardRect = [value CGRectValue]; // 这里得到了键盘的frame
    // 你的操作，如键盘出现，控制视图上移等
    
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
        
        BrowserPlugin *plugin=[[BrowserPlugin alloc] initWithHybridView:hybridView];
        [plugin execute:command];
        
    }  else if  ([method isEqualToString:@"wxPay"]) {
        
        BrowserPlugin *plugin=[[BrowserPlugin alloc] initWithHybridView:hybridView];
        [plugin execute:command];
        
    } else if([method isEqualToString:@"getLocation"]){
        _locationGettingCallback=callback;
        [self startGettingLocation];
        
        
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

-(NSString*)toJsString:(NSString *)s
{
    return [NSString stringWithFormat: @"\"%@\"", [[[s stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""] stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"] stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]];
}

-(NSString*)stringify:(NSObject *)object
{
    if ([NSJSONSerialization isValidJSONObject:object]) {
        NSError *error;
        NSData *registerData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        return [[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

-(NSString*)decodeUrl:(NSString *)temp{
    return [temp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    
    [self hybridCallback:self.pickImageCallback params:[self stringify:result]];
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


//微信支付
- (void)sendPay
{
    //从服务器获取支付参数，服务端自定义处理逻辑和格式
    //订单标题
    NSString *ORDER_NAME    = @"Ios服务器端签名支付 测试";
    //订单金额，单位（元）
    NSString *ORDER_PRICE   = @"0.01";
    
    //根据服务器端编码确定是否转码
    NSStringEncoding enc;
    //if UTF8编码
    enc = NSUTF8StringEncoding;
    //if GBK编码
    //enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *urlString = [NSString stringWithFormat:@"%@?plat=ios&order_no=%@&product_name=%@&order_price=%@",
                           SP_URL,
                           [[NSString stringWithFormat:@"%ld",time(0)] stringByAddingPercentEscapesUsingEncoding:enc],
                           [ORDER_NAME stringByAddingPercentEscapesUsingEncoding:enc],
                           ORDER_PRICE];
    
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.openID              = [dict objectForKey:@"appid"];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            }else{
                [self alert:@"提示信息" msg:[dict objectForKey:@"retmsg"]];
            }
        }else{
            [self alert:@"提示信息" msg:@"服务器返回错误，未获取到json对象"];
        }
    }else{
        [self alert:@"提示信息" msg:@"服务器返回错误"];
    }
}


- (void)sendWXPay_demo
{
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
}

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}

@end
