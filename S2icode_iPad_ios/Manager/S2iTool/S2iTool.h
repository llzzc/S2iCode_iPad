//
//  S2iTool.h
//  S2iPhone
//
//  Created by txm on 14/12/16.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
/*
    描述：S2i工具类
    
    1. 警告：Implicit declaration of function 'sysctlbyname' is invalid in C99。
       解决办法：该问题是因为通过C调用了unix/linux 底层接口，所以需要调整c语言的编译选项。
                搜索：C Language Dialect 选：CNU89 [-std=gnu89] .
    2. 报错： Declaration of 'sysctlbyname' must be imported from module 'Darwin.sys.sysctl' before it is required
       解决办法： 导入 #include <sys/types.h> 和 #include <sys/sysctl.h>

 
 */

#import <Foundation/Foundation.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import "S2iClientManager.h"
#include "detect_param.h"

/**
 *  拍照模式
 */
typedef enum
{
    ENUM_CAPTURE_MODEL_HAND,    //手动
    ENUM_CAPTURE_MODEL_AUTO     //自动
}enumCaptureModel;



//[枚举]标尺模式
typedef enum
{
    RULER_MODE_PAPER_THREE_POINT = 1,       //纸质 - 3个定位点
    RULER_MODE_PLASTIC_NONE_POINT = 2,      //塑料 - 无定位点
    RULER_MODE_PAPER_NONE_POINT = 3         //纸质 - 无定位点
}RulerMode;




//OCV检测S2I码状态
typedef enum
{
    ENUM_OCV_DETECT_STATE_NOEXIST = 0,   //不存在S2i码
    DETECT_STATE_DPI2000 = 1,
    DETECT_STATE_DPI800 = 2,
    ENUM_OCV_DETECT_STATE_EXIST = 3,      //存在S2i码
    ENUM_DETECT_SIZE_TOO_BIG = 4,
    ENUM_DETECT_SIZE_TOO_SMALL = 5,
    ENUM_DETECT_SIZE_UNDEFINED = 6
}EnumOcvDetectState;






@interface S2iTool : NSObject

/**
 *  object类型 取值
 *
 *  @param defaultName key名称
 *
 *  @return key对应的value
 */
+ (id)objectForKey:(NSString *)defaultName;

/**
 *  object类型 赋值
 *
 *  @param value       值
 *  @param defaultName key名称
 */
+ (void)setObject:(id)value forKey:(NSString *)defaultName;


/**
 *  bool类型 取值
 *
 *  @param defaultName key名称
 *
 *  @return key对应的value
 */
+ (BOOL)boolForKey:(NSString *)defaultName;

/**
 *  bool类型 赋值
 *
 *  @param value       值
 *  @param defaultName key名称
 */
+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;


/**
 *  获得设备屏幕分辨率
 *
 *  @return 分辨率Size值
 */
+ (CGSize)S2iDeviceScreenSize;


/**
 *  获得“AddPhoneDeviceInfo”接口，PhoneType标签值
 */
+ (NSString *)S2iCurrentPhoneType;


/**
 *  dict -> json
 */
+ (NSString*)dictToJson:(NSDictionary *)dic;

/**
 *  strinf -> dict
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString ;



+ (id)toArrayOrNSDictionary:(NSData *)jsonData;

+ (CGSize)getOcv800FrameRange;
+ (CGSize)getOcv2000FrameRange;

+ (EnumOcvDetectState) getDetectState: (CGFloat) imageWidth detectedFrameWidth: (CGFloat) frameWidth with800DPIFrame: (BOOL) is800DPIFrame ;

+ (CGRect) convertDetectedFrameRect:(CGRect) detectedFrame withImageSize: (CGSize) imageSize;

+ (CGRect) expandedDetectedFrameRect: (CGRect) detectedFrame withBorder: (CGFloat) border;

+ (NSInteger) getMaxZoom;

+ (UIColor*) convertRGB: (NSInteger) rgb;

+ (NSDictionary*) readInitJson: (DeviceMode) deviceMode;
+ (NSString*) generateDebugText: (DetectResult*) detectResult withFrameRate: (CGFloat) frameRate withLensPosition: (CGFloat) lensPosition;
@end
