//
//  S2iTool.m
//  S2iPhone
//
//  Created by txm on 14/12/16.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iTool.h"
#import "S2iConfig.h"

#import "DeviceConfigInfoModel.h"

/**
 *  通过SOAP协议，上传到SERVER的手机型号。
 *  不要轻易修改手机型号字符串，SERVER端通过此标识有参数设置。
 *  如必须修改，请先与WEB组沟通。
 */
NSString * STR_SOAP_IPHONE_4 = @"IPHONE_4";
NSString * STR_SOAP_IPHONE_4S = @"IPHONE_4S";
NSString * STR_SOAP_IPHONE_5 = @"IPHONE_5";
NSString * STR_SOAP_IPHONE_5C = @"IPHONE_5C";
NSString * STR_SOAP_IPHONE_5S = @"IPHONE_5S";
NSString * STR_SOAP_IPHONE_6 = @"IPHONE_6";
NSString * STR_SOAP_IPHONE_6PLUS = @"IPHONE_6PLUS";
NSString * STR_SOAP_IPHONE_6S = @"IPHONE_6S";
NSString * STR_SOAP_IPHONE_6SPLUS = @"IPHONE_6SPLUS";
NSString * STR_SOAP_IPHONE_5SE = @"IPHONE_5SE";
NSString * STR_SOAP_IPHONE_OTHER = @"IPHONE_OTHERS";



/**
 *  本地化存储宏
 */
#define S2iUserDefaults [NSUserDefaults standardUserDefaults]

@implementation S2iTool

#pragma mark - 本地化存储

#pragma mark - object类型 取值
+ (id)objectForKey:(NSString *)defaultName {
    return [S2iUserDefaults objectForKey:defaultName];
}

#pragma mark - object类型 赋值
+ (void)setObject:(id)value forKey:(NSString *)defaultName {
    [S2iUserDefaults setObject:value forKey:defaultName];
    [S2iUserDefaults synchronize];  //同步
}

#pragma mark - bool类型 取值
+ (BOOL)boolForKey:(NSString *)defaultName {
    return [S2iUserDefaults boolForKey:defaultName];
}

#pragma mark - bool类型 赋值
+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName {
    [S2iUserDefaults setBool:value forKey:defaultName];
    [S2iUserDefaults synchronize];
}

#pragma mark - 设备常用方法

#pragma mark 设备屏幕分辨率
+(CGSize)S2iDeviceScreenSize {
    //1. 屏幕尺寸
    CGRect rcScreen = [[UIScreen mainScreen] bounds];
    CGSize szScreen = rcScreen.size;
    CGFloat fScale = [UIScreen mainScreen].scale; //比例
    //2. 分辨率
    return CGSizeMake(szScreen.width*fScale, szScreen.height*fScale);
}

#pragma mark - 获得当前手机类型。用于“AddPhoneDeviceInfo”接口，PhoneType标签值
+ (NSString *)S2iCurrentPhoneType {
    DeviceMode enReturn = [S2iClientManager deviceModel];
    switch (enReturn) {
        case IPHONE_4:
            return STR_SOAP_IPHONE_4;
        case IPHONE_4S:
            return STR_SOAP_IPHONE_4S;
        case IPHONE_5:
            return STR_SOAP_IPHONE_5;
        case IPHONE_5C:
            return STR_SOAP_IPHONE_5C;
        case IPHONE_5S:
            return STR_SOAP_IPHONE_5S;
        case IPHONE_6:
            return STR_SOAP_IPHONE_6;
        case IPHONE_6PLUS:
            return STR_SOAP_IPHONE_6PLUS;
        case IPHONE_6S:
            return STR_SOAP_IPHONE_6S;
        case IPHONE_6SPLUS:
            return STR_SOAP_IPHONE_6SPLUS;
        case IPHONE_5SE:
            return STR_SOAP_IPHONE_5SE;
        default:
            return STR_SOAP_IPHONE_OTHER;
    }
}



+ (NSString*)dictToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}



+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        S2iLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


+ (id)toArrayOrNSDictionary:(NSData *)jsonData {
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil) {
        return jsonObject;
    } else {
        // 解析错误
        return nil;
    }
}

+ (CGSize)getOcv800FrameRange {
    CGSize range = CGSizeZero;
    DeviceConfigInfoModel* deviceConfigInfo = [[S2iClientManager sharedS2iClientManager] getDeviceConfigInfo];
    if (deviceConfigInfo) {
        range = CGSizeMake([deviceConfigInfo.DPI800RangeMax integerValue] /100.0, [deviceConfigInfo.DPI800RangeMin integerValue]/100.0);
    } else {
        DeviceMode model = [S2iClientManager deviceModel];
        //S2iLog(@"model===%u", model);
        if (model == IPHONE_6SPLUS) {
            range = CGSizeMake(0.59, 0.4);
        } else if (model == IPHONE_6PLUS) {
            range = CGSizeMake(0.67, 0.55);
        } else if (model == IPHONE_6 ) {
            range = CGSizeMake(0.73, 0.42);
        } else if (model == IPHONE_6S) {
            range = CGSizeMake(0.53, 0.38);
        } else if (model== IPHONE_5C || model== IPHONE_5) {
            range = CGSizeMake(0.55, 0.4);
        } else if (model == IPHONE_5S){
            range = CGSizeMake(0.55, 0.38);
        } else if (model==IPHONE_4S || model==IPHONE_4) {
            range = CGSizeMake(0.74, 0.48);
        } else {
            range = CGSizeMake(0.65, 0.5);
        }
    }
    return range;
}

+ (CGSize)getOcv2000FrameRange {
    CGSize range = CGSizeZero;
    
    DeviceConfigInfoModel* deviceConfigInfo = [[S2iClientManager sharedS2iClientManager] getDeviceConfigInfo];
    if (deviceConfigInfo) {
        range = CGSizeMake([deviceConfigInfo.DPI2000RangeMax integerValue]/100.0, [deviceConfigInfo.DPI2000RangeMin integerValue]/100.0);
    } else {
        DeviceMode model = [S2iClientManager deviceModel];
        //S2iLog(@"model===%u", model);
        if (model == IPHONE_6SPLUS) {
            range = CGSizeMake(0.36, 0.3);
        } else if (model == IPHONE_6PLUS) {
            range = CGSizeMake(0.4, 0.26);
        } else if (model == IPHONE_6) {
            range = CGSizeMake(0.4, 0.3);
            //range = CGSizeMake(0.7, 0.2);
        } else if (model == IPHONE_6S) {
            range = CGSizeMake(0.32, 0.27);
        } else if (model== IPHONE_5C || model== IPHONE_5) {
            range = CGSizeMake(0.34, 0.28);
        } else if (model == IPHONE_5S) {
            range = CGSizeMake(0.3, 0.26); // 0.28 best
        } else if (model==IPHONE_4S || model==IPHONE_4) {
            range = CGSizeMake(0.40, 0.36); // 0.38 best
        }
    }
    return range;
}


+ (BOOL) isB800dpi: (CGFloat) imageWidth detectedFrameWidth: (CGFloat) frameWidth {
    
    CGSize range = [S2iTool getOcv800FrameRange];
    CGFloat rate = frameWidth/imageWidth;
    if (range.width >= rate && range.height <= rate) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL) isB2000dpi: (CGFloat) imageWidth detectedFrameWidth: (CGFloat) frameWidth {
    
    CGSize range = [S2iTool getOcv2000FrameRange];
    CGFloat rate = frameWidth/imageWidth;
    if (range.width >= rate && range.height <= rate) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL) isB800dpiSmaller: (CGFloat) imageWidth detectedFrameWidth: (CGFloat) frameWidth {
    
    CGSize range = [S2iTool getOcv800FrameRange];
    CGFloat rate = frameWidth/imageWidth;
    if (range.height > rate && rate > 0.0) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL) isB800dpiBigger: (CGFloat) imageWidth detectedFrameWidth: (CGFloat) frameWidth {
    CGSize range = [S2iTool getOcv800FrameRange];
    CGFloat rate = frameWidth/imageWidth;
    if (range.width < rate) {
        return YES;
    } else {
        return NO;
    }
}

+(BOOL) isB2000dpiSmaller: (CGFloat) imageWidth detectedFrameWidth: (CGFloat) frameWidth {
    
    CGSize range = [S2iTool getOcv2000FrameRange];
    CGFloat rate = frameWidth/imageWidth;
    if (range.height > rate && rate > 0.0) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL) isB2000dpiBigger: (CGFloat) imageWidth detectedFrameWidth: (CGFloat) frameWidth {
    CGSize range = [S2iTool getOcv2000FrameRange];
    CGFloat rate = frameWidth/imageWidth;
    if (range.width < rate) {
        return YES;
    } else {
        return NO;
    }
}

+(BOOL) isB2000_800dpi: (CGFloat) imageWidth detectedFrameWidth: (CGFloat) frameWidth {
    CGSize range2000 = [S2iTool getOcv2000FrameRange];
    CGFloat rate = frameWidth/imageWidth;
    CGSize range800 = [S2iTool getOcv800FrameRange];
    if (range2000.width < rate && rate < range800.height) {
        return YES;
    } else {
        return NO;
    }
}


+ (EnumOcvDetectState) getDetectState: (CGFloat) imageWidth detectedFrameWidth: (CGFloat) frameWidth with800DPIFrame: (BOOL) is800DPIFrame {
    EnumOcvDetectState detectState = ENUM_OCV_DETECT_STATE_NOEXIST;
    if ([S2iConfig sharedS2iConfig].autoFrameDetect) {
        if (is800DPIFrame) {
            if ([self isB800dpi:imageWidth detectedFrameWidth:frameWidth]) {
                detectState = DETECT_STATE_DPI800;
            } else if ([self isB800dpiBigger:imageWidth detectedFrameWidth:frameWidth]) {
                detectState = ENUM_DETECT_SIZE_TOO_BIG;
            } else if ([self isB800dpiBigger:imageWidth detectedFrameWidth:frameWidth]) {
                detectState = ENUM_DETECT_SIZE_TOO_SMALL;
            }
        } else {
            if ([self isB2000dpi:imageWidth detectedFrameWidth:frameWidth]) {
                detectState = DETECT_STATE_DPI2000;
            } else if ([self isB2000dpiSmaller:imageWidth detectedFrameWidth:frameWidth]) {
                detectState = ENUM_DETECT_SIZE_TOO_SMALL;
            } else if ([self isB2000dpiBigger: imageWidth detectedFrameWidth:frameWidth]) {
                detectState = ENUM_DETECT_SIZE_TOO_BIG;
            }
        }
        
    } else {
        if ([self isB800dpi:imageWidth detectedFrameWidth:frameWidth]) {
            detectState = DETECT_STATE_DPI800;
        } else if ([self isB800dpiBigger:imageWidth detectedFrameWidth:frameWidth]) {
            detectState = ENUM_DETECT_SIZE_TOO_BIG;
        } else if ([self isB2000dpi:imageWidth detectedFrameWidth:frameWidth]) {
            detectState = DETECT_STATE_DPI2000;
        } else if ([self isB2000dpiSmaller:imageWidth detectedFrameWidth:frameWidth]) {
            detectState = ENUM_DETECT_SIZE_TOO_SMALL;
        }
    }
    
    return detectState;
}


+ (CGRect) convertDetectedFrameRect:(CGRect) detectedFrame withImageSize: (CGSize) imageSize {
    CGRect convertScreenFrame;
    // 得到图片尺寸和屏幕像素尺寸的倍率：图片的宽／屏幕高的像素
    double rate = imageSize.width/SCREEN_HEIGHT;
    S2iLog(@"rate=====%lf", rate);
    // 旋转区域90度
    CGRect rotatedFrame = CGRectMake(imageSize.height - detectedFrame.origin.y - detectedFrame.size.height, detectedFrame.origin.x, detectedFrame.size.height, detectedFrame.size.width);
    // 缩小区域
    double diff = (imageSize.height/rate-SCREEN_WIDTH)/2;
    S2iLog(@"diff=====%lf", diff);
    convertScreenFrame = CGRectMake(rotatedFrame.origin.x/rate - diff, rotatedFrame.origin.y/rate, rotatedFrame.size.width/rate, rotatedFrame.size.height/rate);
    S2iLog(@"convertScreenFrame=====%@", NSStringFromCGRect(convertScreenFrame));
    

    return convertScreenFrame;
}
+ (CGRect) expandedDetectedFrameRect: (CGRect) detectedFrame withBorder: (CGFloat) border {
    
    CGRect expandedDetectedFrame = CGRectMake(detectedFrame.origin.x - border , detectedFrame.origin.y - border, detectedFrame.size.width + border*2, detectedFrame.size.height + border*2);
    
    expandedDetectedFrame.size.width = expandedDetectedFrame.size.height * 0.94;
    
    return expandedDetectedFrame;
}

+ (NSInteger) getMaxZoom {
    DeviceConfigInfoModel* deviceConfigInfo = [S2iClientManager sharedS2iClientManager].getDeviceConfigInfo;
    return [deviceConfigInfo.Zoom integerValue];
}

+ (UIColor*) convertRGB: (NSInteger) rgb {
    // 0xa9932e
    CGFloat red = ((rgb >> 16) & 0xFF )/255.0;
    CGFloat green = ((rgb >> 8) & 0xFF )/255.0;
    CGFloat blue = (rgb & 0xFF )/255.0;
    UIColor* color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    return color;
}

+ (NSDictionary*) readInitJson: (DeviceMode) deviceMode {
    NSString *Json_path= [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/clientInit.json"];
    //==Json数据
    NSData *data=[NSData dataWithContentsOfFile:Json_path];
    //==JsonObject
    NSError *error;
    NSMutableDictionary *dJSON = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingMutableContainers
                                                    error:&error];
    
    switch (deviceMode) {
        case IPHONE_6:
            return  [dJSON objectForKey:@"IPHONE_6"];
        default:
            return  [dJSON objectForKey:@"IPHONE_6"];
    }
}

+ (NSString*) generateDebugText: (DetectResult*) detectResult withFrameRate: (CGFloat) frameRate withLensPosition: (CGFloat) lensPosition {
    if (detectResult) {
        DeviceConfigInfoModel* deviceConfigInfo = [S2iClientManager sharedS2iClientManager].getDeviceConfigInfo;
        NSString* debugText = [NSString stringWithFormat:@"%lf-%lf", frameRate, lensPosition];
        float eMetricThreshold = 0;
        int minDistToThreshold = 0;
        int minDiffBW = 0;
        int maxQuotAmplitudeBW = 0;
        int minEdgeEnergy = 0;
        //是否启用本地参数
        if ([S2iConfig sharedS2iConfig].localData) {
            eMetricThreshold = [[S2iConfig sharedS2iConfig].eMetricThreshold floatValue];
            minDistToThreshold = [[S2iConfig sharedS2iConfig].minDistToThreshold intValue];
            minDiffBW = [[S2iConfig sharedS2iConfig].minDiffBW intValue];
            maxQuotAmplitudeBW = [[S2iConfig sharedS2iConfig].maxQuotAmplitudeBW intValue];
            minEdgeEnergy = [[S2iConfig sharedS2iConfig].minEdgeEnergy intValue];
        }else{
            eMetricThreshold = [deviceConfigInfo.EMetricThreshold floatValue];
            minDistToThreshold = [deviceConfigInfo.MinDistToThreshold intValue];
            minDiffBW = [deviceConfigInfo.MinDiffBW intValue];
            maxQuotAmplitudeBW = [deviceConfigInfo.MaxQuotAmplitudeBW intValue];
            minEdgeEnergy = [deviceConfigInfo.MinEdgeEnergy intValue];
        }

        NSString* testText = [NSString stringWithFormat:@"%.02f>%.02f %d>%d %d>=%d %d<%d %d>%d (%@)",
                              detectResult->EMetricThreshold, eMetricThreshold,
                              detectResult->MinDistToThreshold, minDistToThreshold,
                              detectResult->MinDiffBW, minDiffBW,
                              detectResult->MaxQuotAmplitudeBW, maxQuotAmplitudeBW,
                              detectResult->MinEdgeEnergy, minEdgeEnergy,
                              debugText
                              ];
        
        return testText;
    } else {
        return @"";
    }
}

@end
