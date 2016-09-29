//
//  S2iLocationManager.m
//  S2iPhone
//
//  Created by txm on 14/12/16.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iLocationManager.h"

@interface S2iLocationManager()
{
    CLLocationManager * _locationManager;   //GPS定位
}
@end



@implementation S2iLocationManager




#pragma mark - 开启定位
- (void)startLocation;
{
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
    }
    _locationManager.delegate = self;                               //设置委托
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;     //设置精度
    //_locationManager.distanceFilter = 1000.0f;                      //设置距离筛选器distanceFilter，下面表示设备至少移动1000米，才通知委托更新
    //_locationManager.distanceFilter = kCLDistanceFilterNone;        //没有筛选器的默认设置
    
    //判断IOS8
    if([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        //[_locationManager requestAlwaysAuthorization];              // 永久授权
        [_locationManager requestWhenInUseAuthorization];           //使用中授权
    }
    //启动位置更新
    [_locationManager startUpdatingLocation];
}

- (void)startLocationWithCompleteHandler:(void (^)())handler
{
    self.completionHandler = handler;
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
    }
    _locationManager.delegate = self;                               //设置委托
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;     //设置精度
    //_locationManager.distanceFilter = 1000.0f;                      //设置距离筛选器distanceFilter，下面表示设备至少移动1000米，才通知委托更新
    //_locationManager.distanceFilter = kCLDistanceFilterNone;        //没有筛选器的默认设置
    
    //判断IOS8
    if([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        //[_locationManager requestAlwaysAuthorization];              // 永久授权
        [_locationManager requestWhenInUseAuthorization];           //使用中授权
    }
    
    //启动位置更新
    [_locationManager startUpdatingLocation];
}





#pragma mark - 停止定位
- (void)stopLocation
{
    if (_locationManager)
    {
        [_locationManager stopUpdatingLocation];    //关闭定位服务
        _locationManager = nil;
    }
}

#pragma mark - CLLocationManagerDelegate



#pragma mark 经纬度信息
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    if ([_delegate respondsToSelector:@selector(locationGPS:)])
    {
        //新坐标传递过去
        [_delegate locationGPS:newLocation];
    }
}




#pragma mark 错误
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //1. 停止定位
    [self stopLocation];
    
    S2iLog(@"location Error: %@",[error localizedDescription]);
    
    //2. 根据错误编码，获得定位失败原因
    switch([error code])
    {
            //定位服务已被关闭
        case kCLErrorDenied:
        {
            //Do something...
            S2iLog(@"定位服务已被关闭，请前往设置页面打开!");
            [[S2iConfig sharedS2iConfig] setGps:NO];
            if (self.completionHandler) {
                self.completionHandler();
                self.completionHandler = nil; // <- Don't forget this!
            }
        }
            break;
            
            //位置服务不可用
        case kCLErrorLocationUnknown:
        {
//            [[[UIAlertView alloc] initWithTitle:@"系统提示" message:@"位置服务不可用!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            //Do something else...
            S2iLog(@"位置服务不可用!");
        }
            break;
            
            //定位发生错误
        default:
        {
//            [[[UIAlertView alloc] initWithTitle:@"系统提示" message:@"定位发生错误!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            S2iLog(@"定位发生错误!");
        }
            break;
    }
    
    
}




@end
