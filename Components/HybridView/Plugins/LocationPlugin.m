//
//  JavaScriptAlert.m
//  Auto273
//
//  Created by Miku on 14-11-2.
//  Copyright (c) 2014年 Miku. All rights reserved.
//
#import "LocationPlugin.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationPlugin ()<CLLocationManagerDelegate>{
    
    CLLocationManager *_locationManager;
    NSString *_callbackJsFn;
}
@end

@implementation LocationPlugin


-(void)execute:(NSDictionary *)command{
    _callbackJsFn=[command valueForKey:@"callback"];
    
    
    //<--定位管理器
    if (_locationManager==nil) {
        _locationManager=[[CLLocationManager alloc]init];
    }
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
        
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        if (_locationManager.delegate==nil) {
            //设置代理
            _locationManager.delegate=self;
        }
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

//CLLocationManagerDelegate的代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
    
    [_hybridView callback:_callbackJsFn params:@{
                                                 @"longitude":[NSNumber numberWithDouble:  coordinate.longitude],
                                                 @"latitude":[NSNumber numberWithDouble:  coordinate.latitude],
                                                 @"altitude":[NSNumber numberWithDouble:  location.altitude],
                                                 @"course":[NSNumber numberWithDouble:  location.course],
                                                 @"speed":[NSNumber numberWithDouble:  location.speed]
                                                 }];
}

@end