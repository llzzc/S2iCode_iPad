//
//  S2iCameraManager.h
//  S2iPhone
//
//  Created by txm on 14/12/19.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
/*
    描述：相机管理类
    1. 导入AVFoundation.framework自定义相机框架。
    2. 明确AVFoundation里面的几个对象：
        2.1 AVCaptureDevice - 代表抽象的硬件设备。
        2.2 AVCaptureInput - 代表输入设备（可以是它的子类），它配置抽象硬件设备的ports。
        2.3 AVCaptureOutput - 代表输出数据，管理着输出到一个movie或者图像。
        2.4 AVCaptureSession - 它是input和output的桥梁。它协调着intput到output的数据传输。
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>




@protocol S2iCameraManagerDelegate <NSObject>

@optional

/**
 *  [代理方法]：拍照
 *
 *  @param imageDataSampleBuffer 拍照图片数据
 */
- (void)cameraManagerWithStillImage:(CMSampleBufferRef)imageDataSampleBuffer;


/**
 *  [代理方法]：视频流
 *
 *  @param sampleBuffer 视频流一帧数据
 */
- (void)cameraManagerWithVideoOutput:(CMSampleBufferRef)sampleBuffer;

- (void) cameraManagerWithBarcodeResult: (NSString*) barcode;

@end



@interface S2iCameraManager : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate>
{
    //AVCaptureVideoOrientation orientation;          //设备取景方向（枚举）
    AVCaptureSession * session;                     //输入输出的桥梁。它协调着intput到output的数据传输。
    AVCaptureDeviceInput * videoInput;              //视频输入设备
    AVCaptureStillImageOutput * stillImageOutput;   //输出（拍照）
    AVCaptureVideoDataOutput * videoDataOutput;     //输出（视频）
    dispatch_queue_t videoDataOutputQueue;          //视频输出的操作队列
}


@property (nonatomic, assign) id<S2iCameraManagerDelegate> delegate;    //相机代理

@property (nonatomic, assign) BOOL barcode;


/**
 *  初始化相机
 */
- (void)setupCamera;

/**
 *  获取Session
 *
 *  @return AVCaptureSession实例
 */
- (AVCaptureSession *)getSession;

/**
 *  获取视频输入
 *
 *  @return AVCaptureDeviceInput实例
 */
- (AVCaptureDeviceInput *)getVideoInput;


- (AVCaptureDevice *) cameraWithBackPosition;
/**
 *  设置拍照变焦
 *
 *  @param zoomFactor 变焦倍数
 */
- (void)setStillImageZoom:(CGFloat)zoomFactor withActiveFormat: (BOOL) isSetActiveFormat;




/**
 *  开启手电筒
 *
 *  @param isEnable 开/关
 */
- (void)setTorchState:(BOOL)isEnable;




/**
 *  拍照
 */
- (void)captureStillImage;



/**
 *  开启视频数据
 */
- (void)startVideoDataOutput;


/**
 *  停止视频流数据
 */
- (void)stopVideoDataOutput;



/**
 *  设置拍照变焦
 *
 *  @param zoomFactor 变焦倍数
 */
- (void)setZoom:(CGFloat)zoomFactor;

- (CGFloat) getLensPosition;

- (void) setFocusPoint: (CGPoint) focusPoint;

- (CGFloat) getCameraCurrentZoom;
- (BOOL) isTorchOn;
@end
