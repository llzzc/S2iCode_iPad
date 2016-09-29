//
//  S2iClientManager.h
//  S2iPhone
//
//  Created by txm on 14/12/19.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
/*
    描述：客户端方法管理类
    1.  OpenCV库添加时。
        错误1：“list file not found”是经常出现的错误之一，
        解决办法： a)进入“Build Settings”，
                  b)修改“Apple LLVM compiler 4.2 - Language”中“Comlile Sources As”的值为“Objective-C++”。
    2. 
 
 */

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AudioToolbox/AudioServices.h> //声音
#import <AudioToolbox/AudioToolbox.h>
#import "S2iSqliteManager.h"
#import "S2iLocationManager.h"
#import "KSReachability.h" //检测网络
#import "S2iSoftUpModel.h"
#import "S2iPdtFlowIdModel.h"
#import "SerialNoModel.h"
#include "DeviceConfigInfo.h"

#import "SoftwareVersionModel.h"

//音频ID
static SystemSoundID shake_sound_male_id = 0;


//图像清晰度分数
#define N_IMAGE_HISTSCORE_YELLOW_LEVEL 60
#define N_IMAGE_HISTSCORE_RED_LEVEL 50

//图像压缩参数
#define F_DEF_LOCALJPGCOMPRESS 0.5

//图像尺寸
#define N_S2I_RAW_IMAGE_SIZE 620


//IPHONE 型号枚举
typedef enum
{
    IPHONE_4 = 0,
    IPHONE_4S = 1,
    IPHONE_5 = 2,
    IPHONE_5C = 3,
    IPHONE_5S = 4,
    IPHONE_OTHER = 5,
    IPHONE_6 = 6,
    IPHONE_6PLUS = 7,
    IPHONE_6S = 8,
    IPHONE_6SPLUS = 9,
    IPHONE_5SE = 10
}DeviceMode;


//OCV图像清晰枚举
typedef enum
{
    ImageHistScoreLevel_Red = 0,
    ImageHistScoreLevel_Yellow = 1,
    ImageHistScoreLevel_Green = 2
}EnumImageHistScoreLevel;


@class KSReachability;

#pragma mark - 协议

//声明协议，注意：协议名，最好要以类名开头。
@protocol S2iClientManagerDelegate <NSObject>

@optional   //不请求实现代理方法
/**
 *  接收“商品签章解码”数据
 *
 *  @param decPdtModel “商品签章解码”实体类
 */
- (void)receivedDecodedText:(S2iDecPdtModel *)decPdtModel;


/**
 *  [new]序列号查询 -- 成功
 *
 *  @param flowModel
 */
- (void)receivedWithModel:(SerialNoModel *)model;

/**
 *  [new]序列号查询 -- 失败
 *
 */
- (void)receivedWithFailure;

/**
 *  接收“设备ID”值
 *
 *  @param aDeviceId 设备ID值
 */
- (void)receivedDeviceId:(NSInteger)aDeviceId;
/**
 *  接收“设备ID”值
 *
 *  @param aDeviceId 设备ID值
 */
- (void)receivedWithPics:(NSArray *)pics;
/**
 *  请求服务器失败
 *
 */
- (void)requestServerError;


- (void)softwareUpdateAvailable:(SoftwareVersionModel *)softwareVersionModel;

@end

@class DeviceConfigInfoModel;



@interface S2iClientManager : NSObject<S2iLocationManagerDelegate, UIAlertViewDelegate>
{
    S2iSqliteManager * _sqliteManager;            //数据库管理类
    S2iLocationManager * _locationManager;         //GPS管理类
    
    
    
    NSInteger imageShapeScore;                  //OCV检测出得图像形状得分
    NSInteger imageHistScore;                   //OCV检测出的图像清晰度得分
    
    
    NSString * s2iImageName;                    //s2i图像名，用于存储数据库，从数据库取数据时进行比对条件
    NSString * qrImageName;                     //QR图像名
    
    
    NSMutableArray * s2iImagesList;             //S2i解码图像数组
    NSMutableArray * qrImagesList;              //QR解码图像数组
    
    
    CLLocation * _locationGPS;                  //当前设备的GPS值
    
    //S2iDecPdtModel * decPdtModel;
    S2iSoftUpModel * _softupModel;               //版本更新实体类
    
    float fIntenValue;  //强度值
    float fAvaValue;    //均值
    
    UIImage *decSaveImage; //保持解码图像
    
    
    DeviceConfigInfoModel* deviceConfigInfoModel;
    NSArray<NSString*> *qrWhiteUrls;
    SoftwareVersionModel* softwareVersionModel;
    
}



//单例
single_interface(S2iClientManager)



//代理
@property (nonatomic, weak) id<S2iClientManagerDelegate> delegate;


/**
 *  判断图像清晰度
 *
 *  @return 小于60，返回NO，其余返回YES
 */
- (EnumImageHistScoreLevel)isCapturedImageSharp;


- (NSInteger) getImageHistScore;

/**
 *  加载“历史记录”的数据
 *
 *  @return “小章解码数据模型”的数组
 */
- (NSMutableArray *)loadS2iImagesHistory;



/**
 *  删除“小章解码”的数据库中的数据
 *
 *  @param model 根据“小章解码”数据模型
 */
- (void)removeWithDecPdtModel:(S2iDecPdtModel *)model;





/**
 *  OCV没有检测到S2I码，图像进行剪切。
 *
 *  @param aImage     原图
 *  @param aCropFrame rect值
 *
 *  @return 剪切的图像
 */
- (UIImage *)processImage:(UIImage *)aImage withCropFrame:(CGRect)aCropFrame;


@property (nonatomic, copy) void (^getNetworkReachable)(BOOL hasInternet);



/**
 *  检测当前网络情况
 *
 *  @return 没有网络=NO， 有网络(wifi或蜂窝)=YES
 */
typedef void(^BlockType) (BOOL hasInternet);
@property (nonatomic, strong)BlockType blockDemo;

+ (void) isNetworkReachableWithCompleted: (BlockType) blockDemo;


#pragma mark - QR码存到数据库
/**
 *  QR码 插入数据库
 *
 *  @param model   QR解码信息
 *  @param qrImage QR图像
 */
- (void)insertTableQRWithInfo:(NSString *)info image:(UIImage *)qrImage;


#pragma mark - 历史记录中QR解码图像
/**
 *  查询数据库中QR数据
 *
 *  @return 数组
 */
- (NSMutableArray *)loadQRImagesHistory;

/**
 *  删除QR数据
 *
 *  @param model QR数据模型类
 */
- (void)removeWithQRModel:(S2iQRModel *)model;




+ (DeviceMode)deviceModel;

+ (NSString *)newImageFileName;


- (NSString*)saveS2iImage:(UIImage *)image;

- (void) startGPS;
- (void) startGPSwithCompletedHandler:(void (^)())handler;
- (void) stopGPS;
- (CLLocation*) getCurrentLocation;

- (DeviceConfigInfoModel*) getDeviceConfigInfo;

- (void)playSound;

- (void)addDecPdtWithImageName:(NSString *)decImageName model:(S2iDecPdtModel *)model;

- (BOOL) isQRWhiteUrl: (NSString*) url;
- (void) requestClientInit;

- (SoftwareVersionModel*) getSoftwareVersionModel;
- (BOOL) hasSoftwareUpdate;

@end
