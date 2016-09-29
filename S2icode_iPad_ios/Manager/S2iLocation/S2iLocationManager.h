//
//  S2iLocationManager.h
//  S2iPhone
//
//  Created by txm on 14/12/16.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
/*
    描述：GPS定位管理类
    
        1. 添加CoreLocation.framework
        2. 引用#import <CoreLocation/CoreLocation.h>
        3. 遵守<CLLocationManagerDelegate>代理
        4. IOS8有所改变，必须经用户同意定位服务。（*）
        5. 在plist添加两项
            a)NSLocationWhenInUseDescription    允许在前台获取GPS的描述
            b)NSLocationAlwaysUsageDescription  允许在后台获取GPS的描述
        6. 在代理方法中，可获得经纬度坐标或错误信息等。
 
 */

#import <Foundation/Foundation.h>



@protocol S2iLocationManagerDelegate <NSObject>

@optional

/**
 *  当前设备GPS坐标
 *
 *  @param location 坐标
 */
- (void)locationGPS:(CLLocation *)location;

@end





@interface S2iLocationManager : NSObject<CLLocationManagerDelegate>


@property (nonatomic, weak) id<S2iLocationManagerDelegate> delegate;


@property (nonatomic, copy) void (^completionHandler)();


/**
 *  开启定位
 */
- (void)startLocation;
- (void)startLocationWithCompleteHandler:(void (^)())handler;

/**
 *  停止定位
 */
- (void)stopLocation;




@end
