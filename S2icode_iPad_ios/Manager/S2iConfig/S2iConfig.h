//
//  S2iConfig.h
//  S2iPhone
//
//  Created by txm on 14/12/22.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
/*
    描述：S2i配置文件
 */

#import <Foundation/Foundation.h>



//枚举：标尺状态
typedef enum
{
    ENUM_RULER_THREEPOINT_STATE = 0,           
    ENUM_RULER_RIGHRTANGEL_STATE = 1
} EnumRulerState;

typedef enum {
    DETECT_MODE_OPENCV = 0,
    DETECT_MODE_S2I = 1
} EnumDetectMode;

@interface S2iConfig : NSObject
//单例
single_interface(S2iConfig)


//第一次加载配置文件
@property (nonatomic, assign) BOOL configNoFirst;


//免责声明
@property (nonatomic, assign) BOOL protocol;


//设置
@property (nonatomic, assign) BOOL gps;            //卫星定位
@property (nonatomic, assign) BOOL autoDecode;     //自动解码
@property (nonatomic, assign) BOOL scoreShow;      //得分展示


//视频流控制体
@property (nonatomic, assign) BOOL autoCapture;               //自动拍照
@property (nonatomic, assign) BOOL scale;                     //缩放
@property (nonatomic, assign) EnumRulerState ruler;           //标尺
@property (nonatomic, assign) BOOL torch;                     //手电筒


//设备ID号
@property (nonatomic, assign) NSInteger deviceId;       //手机型号，在服务器数据库中对应一个ID值


//重新拍摄
@property (nonatomic, assign) BOOL resetCapture;            //重新拍摄



// 视频流的图像清晰度
@property (nonatomic, assign) NSInteger avImgHist;



@property (nonatomic, assign) NSInteger topH;
@property (nonatomic, assign) NSInteger topX;


@property (nonatomic, assign) BOOL manualZoom;            //zoom
@property (nonatomic, assign) CGFloat zoom;

@property (nonatomic, assign) BOOL sound;            //sound
@property (nonatomic, assign) EnumDetectMode detectMode;
@property (nonatomic, assign) BOOL directImage;            //sound


@property (nonatomic, strong) NSString *clientInit;

@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, assign) BOOL debug;            //debug
@property (nonatomic, assign) BOOL autoFrameDetect;            //debug
@property (nonatomic, assign) BOOL localData;   //debug 是否启用本地参数
@property (nonatomic, assign) BOOL helpMessage;   //是否显示帮助信息

@property (nonatomic, strong) NSString *eMetricThreshold;   //debug
@property (nonatomic, strong) NSString *minDistToThreshold; //debug
@property (nonatomic, strong) NSString *minDiffBW;          //debug
@property (nonatomic, strong) NSString *maxQuotAmplitudeBW; //debug
@property (nonatomic, strong) NSString *minEdgeEnergy;      //debug

@property (nonatomic, strong) NSString *buildNumber;



@property (nonatomic, assign) BOOL firstTimeLupeMode;
@property (nonatomic, assign) BOOL firstTimeMacroMode;

@property (nonatomic, assign) BOOL checkFocusDistance;

@property (nonatomic, assign) BOOL hideUpdateBadge;
/**
 *  初始化Config
 */
- (void)setupConfig;


@end
