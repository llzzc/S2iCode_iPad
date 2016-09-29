//
//  S2iConfig.m
//  S2iPhone
//
//  Created by txm on 14/12/22.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iConfig.h"


#define S2iUserDefaults [NSUserDefaults standardUserDefaults]

#define STR_CONFIG_NOFIRST @"configNoFirst"         //第一次运行APP

#define STR_CONFIG_PROTOCOL @"protocol"             //免责声明

#define STR_CONFIG_GPS @"gps"                       //卫星定位
#define STR_CONFIG_AUTO_DECODE @"autoDecode"        //自动验证
#define STR_CONFIG_SCORE_SHOW @"scoreShow"          //展示得分


#define STR_CONFIG_AUTO_CAPTURE @"autoCapture"      //自动拍摄
#define STR_CONFIG_SCALE @"scale"                   //缩放
#define STR_CONFIG_RULER @"ruler"                   //标尺
#define STR_CONFIG_TORCH @"torch"                   //手电筒


#define STR_CONFIG_DEVICEID @"deviceId"             //设备ID号


#define STR_CONFIG_RESETCAPTURE @"resetCapture"     //重新拍摄


#define STR_CONFIG_AVIMGHIST @"avImgHist"             //视频流图像清晰度


#define STR_CONFIG_ENETRIC_THRESHOLD  @"eMetricThreshold"
#define STR_CONFIG_MINDIST_THRESHOLD  @"minDistToThreshold"
#define STR_CONFIG_MINDIFF_BW  @"minDiffBW"
#define STR_CONFIG_MAXQUOTAMPLITUDE_BW  @"maxQuotAmplitudeBW"
#define STR_CONFIG_MINEDGE_ENERGY  @"minEdgeEnergy"


#define STR_CONFIG_TOPX  @"topX"
#define STR_CONFIG_TOPH  @"topH"
#define STR_CONFIG_MANUALZOOM  @"manualZoom"
#define STR_CONFIG_ZOOM  @"zoom"

#define STR_CONFIG_SOUND  @"sound"


#define STR_CONFIG_DETECT_MODE  @"detectMode"

#define STR_CONFIG_DIRECT_IMAGE  @"directImage"
#define STR_CONFIG_CLIENT_INIT  @"clientInit"
#define STR_CONFIG_UUID  @"UUID"

#define STR_CONFIG_DEBUG  @"DEBUG"
#define STR_CONFIG_AUTO_FRAME_DETECT  @"AUTO_FRAME_DETECT"
#define STR_CONFIG_BUILD_NUMBER  @"BUILD_NUMBER"

#define STR_CONFIG_LOCAL_DATA  @"LOCAL_DATA"

#define STR_CONFIG_HELP_MESSAGE  @"HELP_MESSAGE"

#define STR_CONFIG_FIRSTTIME_LUPEMODE  @"firstTimeLupeMode"
#define STR_CONFIG_FIRSTTIME_MACROMODE  @"firstTimeMacroMode"

#define STR_CONFIG_CHECK_FOCUS_DISTANCE  @"checkFocusDistance"

#define STR_CONFIG_HIDE_UPDATE_BADGE  @"hideUpdateBadge"

@implementation S2iConfig
single_implementation(S2iConfig)



#pragma mark - 初始化
- (void)setupConfig
{
    S2iLog(@"[self configFirst]===%d", [self configNoFirst]);
    BOOL bFirstRunApp = [self configNoFirst];
    //判断是否是第一次运行APP。
    if (!bFirstRunApp)
    {
        S2iLog(@"第一次执行程序！！！");
        
        //1. 设置下次就不是第一次运行了。
        [self setConfigNoFirst:YES];
        
        //2. 第一次运行APP，初始化！
        [self setupDefConfig];
    }
    else
    {
         S2iLog(@"不是。。。。第一次执行程序！！！");
    }
    
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    if ([self buildNumber] == nil) {
        // first time init
        [self setDirectImage:YES];
        [self setBuildNumber:build];
    } else {
        if ([build integerValue] > [[self buildNumber] integerValue]) {
            // update available
            // Do some changing based on build number
            [self setBuildNumber:build];
            [self setAutoDecode:YES];
            [self setCheckFocusDistance:YES];
        }
    }
}


#pragma mark - 初始化默认值
- (void)setupDefConfig {
    //免责声明
    [self setProtocol:YES];
    
    //1. 设置控制器
    //1) 卫星定位
    [self setGps:YES];
    //2) 自动上传解码
    [self setAutoDecode:YES];
    //3) 展示得分
    [self setScoreShow:YES];
    
    
    
    //2. 视频控制器
    //1) 自动拍照
    [self setAutoCapture:YES];
    //2) 缩放
    [self setScale:YES];
    //3) 标尺
    [self setRuler:ENUM_RULER_RIGHRTANGEL_STATE];   //默认：四个直角
    //4) 手电筒
    [self setTorch:YES];
    
    
    
    //3. 设置ID号
    [self setDeviceId:0];
    
    //4. 重新拍摄
    [self setResetCapture:NO];
    
    
    
    
    // 设置视频流图像质量分数为0分
    [self setAvImgHist:0];
    
    
    [self setTopX:0];
    [self setTopH:0];
    
    [self setManualZoom:NO];
    
    [self setZoom:1];
    
    //
    [self setDetectMode:DETECT_MODE_S2I];
    [self setDirectImage:YES];
    
    [self setCheckFocusDistance:YES];
}


#pragma mark - 第一次运行APP
- (void)setConfigNoFirst:(BOOL)configNoFirst
{
    [S2iUserDefaults setBool:configNoFirst forKey:STR_CONFIG_NOFIRST];
    [S2iUserDefaults synchronize];
}
- (BOOL)configNoFirst
{
    return [S2iUserDefaults boolForKey:STR_CONFIG_NOFIRST];
}


#pragma mark - 免责声明
- (void)setProtocol:(BOOL)protocol
{
    [S2iUserDefaults setBool:protocol forKey:STR_CONFIG_PROTOCOL];
    [S2iUserDefaults synchronize];
}
- (BOOL)protocol
{
    return [S2iUserDefaults boolForKey:STR_CONFIG_PROTOCOL];
}


#pragma mark -  卫星定位
- (void)setGps:(BOOL)gps
{
    [S2iUserDefaults setBool:gps forKey:STR_CONFIG_GPS];
    [S2iUserDefaults synchronize];
}
- (BOOL)gps
{
    return [S2iUserDefaults boolForKey:STR_CONFIG_GPS];
}



#pragma mark - 自动验证
- (void)setAutoDecode:(BOOL)autoDecode
{
    [S2iUserDefaults setBool:autoDecode forKey:STR_CONFIG_AUTO_DECODE];
    [S2iUserDefaults synchronize];
}
- (BOOL)autoDecode
{
    return [S2iUserDefaults boolForKey:STR_CONFIG_AUTO_DECODE];
}


#pragma mark -  展示得分
- (void)setScoreShow:(BOOL)scoreShow
{
    [S2iUserDefaults setBool:scoreShow forKey:STR_CONFIG_SCORE_SHOW];
    [S2iUserDefaults synchronize];
}
- (BOOL)scoreShow
{
    return [S2iUserDefaults boolForKey:STR_CONFIG_SCORE_SHOW];
}

#pragma mark - 自动拍照
- (void)setAutoCapture:(BOOL)autoCapture
{
    [S2iUserDefaults setBool:autoCapture forKey:STR_CONFIG_AUTO_CAPTURE];
    [S2iUserDefaults synchronize];
}
- (BOOL)autoCapture
{
    return [S2iUserDefaults boolForKey:STR_CONFIG_AUTO_CAPTURE];
}


#pragma mark - 缩放
- (void)setScale:(BOOL)scale
{
    [S2iUserDefaults setBool:scale forKey:STR_CONFIG_SCALE];
    [S2iUserDefaults synchronize];
}
- (BOOL)scale
{
    return [S2iUserDefaults boolForKey:STR_CONFIG_SCALE];
}




#pragma mark - 标尺
- (void)setRuler:(EnumRulerState)ruler
{
    [S2iUserDefaults setInteger:ruler forKey:STR_CONFIG_RULER];
    [S2iUserDefaults synchronize];
}
- (EnumRulerState)ruler
{
    return (EnumRulerState)[S2iUserDefaults integerForKey:STR_CONFIG_RULER];
}





#pragma mark - 手电筒
- (void)setTorch:(BOOL)torch
{
    [S2iUserDefaults setBool:torch forKey:STR_CONFIG_TORCH];
    [S2iUserDefaults synchronize];
}
- (BOOL)torch
{
    return [S2iUserDefaults boolForKey:STR_CONFIG_TORCH];
}


- (void) setManualZoom:(BOOL)manualZoom {
    [S2iUserDefaults setBool:manualZoom forKey:STR_CONFIG_MANUALZOOM];
    [S2iUserDefaults synchronize];
    
}

- (BOOL) manualZoom {
    return [S2iUserDefaults boolForKey:STR_CONFIG_MANUALZOOM];
    
}

- (void) setZoom:(CGFloat) zoom {
    [S2iUserDefaults setFloat:zoom forKey:STR_CONFIG_ZOOM];
    [S2iUserDefaults synchronize];
}

- (CGFloat) zoom {
    return [S2iUserDefaults floatForKey:STR_CONFIG_ZOOM];
}



#pragma mark - 设备ID号
- (void)setDeviceId:(NSInteger)deviceId
{
    [S2iUserDefaults setInteger:deviceId forKey:STR_CONFIG_DEVICEID];
    [S2iUserDefaults synchronize];
}
- (NSInteger)deviceId
{
    return [S2iUserDefaults integerForKey:STR_CONFIG_DEVICEID];
}



#pragma mark - 重新拍摄
- (void)setResetCapture:(BOOL)resetCapture
{
    [S2iUserDefaults setBool:resetCapture forKey:STR_CONFIG_RESETCAPTURE];
    [S2iUserDefaults synchronize];
}
- (BOOL)resetCapture
{
    return [S2iUserDefaults boolForKey:STR_CONFIG_RESETCAPTURE];
}



#pragma mark - 设置视频流图像质量分数
- (void)setAvImgHist:(NSInteger)avImgHist
{
    [S2iUserDefaults setInteger:avImgHist forKey:STR_CONFIG_AVIMGHIST];
    [S2iUserDefaults synchronize];
}

- (NSInteger)avImgHist
{
    return [S2iUserDefaults integerForKey:STR_CONFIG_AVIMGHIST];
}


#pragma mark - 视频流topX
- (void)setTopX:(NSInteger)topX
{
    [S2iUserDefaults setInteger:topX forKey:STR_CONFIG_TOPX];
    [S2iUserDefaults synchronize];
}

- (NSInteger)topX
{
    return [S2iUserDefaults integerForKey:STR_CONFIG_TOPX];
}


#pragma mark - 视频流topH
- (void)setTopH:(NSInteger)topH
{
    [S2iUserDefaults setInteger:topH forKey:STR_CONFIG_TOPH];
    [S2iUserDefaults synchronize];
}

- (NSInteger)topH
{
    return [S2iUserDefaults integerForKey:STR_CONFIG_TOPH];
}

- (void) setSound:(BOOL)sound {
    [S2iUserDefaults setBool:sound forKey:STR_CONFIG_SOUND];
    [S2iUserDefaults synchronize];
}

- (BOOL) sound {
    return [S2iUserDefaults boolForKey:STR_CONFIG_SOUND];
}



- (void) setDetectMode:(EnumDetectMode)detectMode {
    [S2iUserDefaults setInteger:detectMode forKey:STR_CONFIG_DETECT_MODE];
    [S2iUserDefaults synchronize];
}

- (EnumDetectMode) detectMode {
    return (EnumDetectMode)[S2iUserDefaults integerForKey:STR_CONFIG_DETECT_MODE];
}

- (void) setDirectImage:(BOOL)directImage {
    [S2iUserDefaults setBool:directImage forKey:STR_CONFIG_DIRECT_IMAGE];
    [S2iUserDefaults synchronize];
}

- (BOOL) directImage {
    return [S2iUserDefaults boolForKey:STR_CONFIG_DIRECT_IMAGE];
}

- (void) setClientInit:(NSString *)clientInit {
    [S2iUserDefaults setObject:clientInit forKey:STR_CONFIG_CLIENT_INIT];
    [S2iUserDefaults synchronize];
}

- (NSString*) clientInit {
    return [S2iUserDefaults stringForKey:STR_CONFIG_CLIENT_INIT];
}

- (void) setUUID:(NSString *)UUID {
    [S2iUserDefaults setObject:UUID forKey:STR_CONFIG_UUID];
    [S2iUserDefaults synchronize];
}

- (NSString*) UUID {
    return [S2iUserDefaults stringForKey:STR_CONFIG_UUID];
}

- (void) setDebug:(BOOL)debug {
    [S2iUserDefaults setBool:debug forKey:STR_CONFIG_DEBUG];
    [S2iUserDefaults synchronize];
}

- (BOOL) debug {
    return [S2iUserDefaults boolForKey:STR_CONFIG_DEBUG];
}

- (void) setAutoFrameDetect:(BOOL)autoFrameDetect {
    [S2iUserDefaults setBool:autoFrameDetect forKey:STR_CONFIG_AUTO_FRAME_DETECT];
    [S2iUserDefaults synchronize];
}

- (BOOL) autoFrameDetect {
    return [S2iUserDefaults boolForKey:STR_CONFIG_AUTO_FRAME_DETECT];
}

- (void) setLocalData:(BOOL)localData {
    [S2iUserDefaults setBool:localData forKey:STR_CONFIG_LOCAL_DATA];
    [S2iUserDefaults synchronize];
}

- (BOOL) localData {
    return [S2iUserDefaults boolForKey:STR_CONFIG_LOCAL_DATA];
}

- (void) setHelpMessage:(BOOL)helpMessage{
    [S2iUserDefaults setBool:helpMessage forKey:STR_CONFIG_HELP_MESSAGE];
    [S2iUserDefaults synchronize];
}
- (BOOL) helpMessage{
    return [S2iUserDefaults boolForKey:STR_CONFIG_HELP_MESSAGE];
}
- (void) setBuildNumber:(NSString *)buildNumber {
    [S2iUserDefaults setObject:buildNumber forKey:STR_CONFIG_BUILD_NUMBER];
    [S2iUserDefaults synchronize];
}

- (NSString*) buildNumber {
    return [S2iUserDefaults stringForKey:STR_CONFIG_BUILD_NUMBER];
}
/**
 *  设置本地参数
 *
 *  @param eMetricThreshold
 */

- (void) setEMetricThreshold:(NSString *)eMetricThreshold{
    [S2iUserDefaults setObject:eMetricThreshold forKey:STR_CONFIG_ENETRIC_THRESHOLD];
    [S2iUserDefaults synchronize];
}

- (NSString*) eMetricThreshold {
    return [S2iUserDefaults stringForKey:STR_CONFIG_ENETRIC_THRESHOLD];
}


- (void) setMinDistToThreshold:(NSString *)minDistToThreshold{
    [S2iUserDefaults setObject:minDistToThreshold forKey:STR_CONFIG_MINDIST_THRESHOLD];
    [S2iUserDefaults synchronize];
}

- (NSString*) minDistToThreshold {
    return [S2iUserDefaults stringForKey:STR_CONFIG_MINDIST_THRESHOLD];
}

- (void) setMinDiffBW:(NSString *)minDiffBW {
    [S2iUserDefaults setObject:minDiffBW forKey:STR_CONFIG_MINDIFF_BW];
    [S2iUserDefaults synchronize];
}

- (NSString*) minDiffBW {
    return [S2iUserDefaults stringForKey:STR_CONFIG_MINDIFF_BW];
}

- (void) setMaxQuotAmplitudeBW:(NSString *)maxQuotAmplitudeBW {
    [S2iUserDefaults setObject:maxQuotAmplitudeBW forKey:STR_CONFIG_MAXQUOTAMPLITUDE_BW];
    [S2iUserDefaults synchronize];
}

- (NSString*) maxQuotAmplitudeBW {
    return [S2iUserDefaults stringForKey:STR_CONFIG_MAXQUOTAMPLITUDE_BW];
}

- (void) setMinEdgeEnergy:(NSString *)minEdgeEnergy {
    [S2iUserDefaults setObject:minEdgeEnergy forKey:STR_CONFIG_MINEDGE_ENERGY];
    [S2iUserDefaults synchronize];
}

- (NSString*) minEdgeEnergy {
    return [S2iUserDefaults stringForKey:STR_CONFIG_MINEDGE_ENERGY];
}



- (void) setFirstTimeLupeMode:(BOOL)firstTimeLupeMode {
    [S2iUserDefaults setBool:firstTimeLupeMode forKey:STR_CONFIG_FIRSTTIME_LUPEMODE];
    [S2iUserDefaults synchronize];
}

- (BOOL) firstTimeLupeMode {
    return [S2iUserDefaults boolForKey:STR_CONFIG_FIRSTTIME_LUPEMODE];
}

- (void) setFirstTimeMacroMode:(BOOL)firstTimeMacroMode {
    [S2iUserDefaults setBool:firstTimeMacroMode forKey:STR_CONFIG_FIRSTTIME_MACROMODE];
    [S2iUserDefaults synchronize];
}

- (BOOL) firstTimeMacroMode {
    return [S2iUserDefaults boolForKey:STR_CONFIG_FIRSTTIME_MACROMODE];
}

- (void) setCheckFocusDistance:(BOOL)checkFocusDistance {
    [S2iUserDefaults setBool:checkFocusDistance forKey:STR_CONFIG_CHECK_FOCUS_DISTANCE];
    [S2iUserDefaults synchronize];
}

- (BOOL) checkFocusDistance {
    return [S2iUserDefaults boolForKey:STR_CONFIG_CHECK_FOCUS_DISTANCE];
}

- (void) setHideUpdateBadge:(BOOL)hideUpdateBadge {
    [S2iUserDefaults setBool:hideUpdateBadge forKey:STR_CONFIG_HIDE_UPDATE_BADGE];
    [S2iUserDefaults synchronize];
}

- (BOOL) hideUpdateBadge {
    return [S2iUserDefaults boolForKey:STR_CONFIG_HIDE_UPDATE_BADGE];
}

@end
