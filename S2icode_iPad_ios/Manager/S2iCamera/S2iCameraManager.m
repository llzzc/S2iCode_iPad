//
//  S2iCameraManager.m
//  S2iPhone
//
//  Created by txm on 14/12/19.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iCameraManager.h"

@interface S2iCameraManager () {
    NSString* barcodeString;
}

@end
@implementation S2iCameraManager


#pragma mark - life cycle

#pragma mark 初始化
- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化图像捕获取向
        //orientation = AVCaptureVideoOrientationPortrait;
    }
    return self;
}

#pragma mark 释放资源
- (void)dealloc {
    S2iLog(@"S2iCameraManager....dealloc.....");
    
    //释放视频输出
    if (videoDataOutput) {
        [session removeOutput:videoDataOutput];
        videoDataOutput = nil;
    }
    //释放视频输入
    if (videoInput) {
        [session removeInput:videoInput];
        videoInput = nil;
    }
    //释放拍照输出
    if (stillImageOutput) {
        [session removeOutput:stillImageOutput];
        stillImageOutput = nil;
    }
    //释放session
    if ([session isRunning]) {
        [session stopRunning];
    }
    session = nil;
}

#pragma mark - Camera Manager

#pragma mark 初始化相机
- (void)setupCamera {
    //1. 创建输入输出桥梁（Session）
    if (session) {
        S2iLog(@"session valid");
    } else {
        session = [[AVCaptureSession alloc] init];
    }
    
    //2. 创建视频输入(后置摄像头)
    NSError * error;
    AVCaptureDevice * cameraBackDevice = [self cameraWithBackPosition];
    videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:cameraBackDevice error:&error];
    if ([session canAddInput:videoInput]) {
        [session addInput:videoInput];
    } else {
        S2iLog(@"input Error :%@", error);
    }
    

    [self setCameraActiveFormat];
    
    //3. 创建拍照输出
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    if ([session canAddOutput:stillImageOutput]) {
        [session addOutput:stillImageOutput];
    } else {
        S2iLog(@"stillImageOutput Error :%@", error);
    }
    
    [session setSessionPreset:                   //视频流          //拍照
     //     AVCaptureSessionPresetInputPriority        //√             //一般
     //     AVCaptureSessionPreset1280x720             //√             //不行
     //     AVCaptureSessionPreset640x480              //X
     //     AVCaptureSessionPreset352x288              //X
     //     AVCaptureSessionPresetLow                  //X
     //     AVCaptureSessionPresetMedium               //X
          AVCaptureSessionPresetHigh                 //√
     //AVCaptureSessionPresetPhoto                  //X（以前）      GOOD not for video
     ];

    
    //需要获得扑捉连接，并确保使用了纵向来扑捉图像。
    AVCaptureConnection * stillImageConnection = [S2iCameraManager connectionWithMediaType:AVMediaTypeVideo fromConnections:[stillImageOutput connections]];
    if ([stillImageConnection isVideoOrientationSupported]) {
        [stillImageConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    }
    
    //4. 视频流输出
    videoDataOutput = [AVCaptureVideoDataOutput new];
    NSDictionary * rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                        [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [videoDataOutput setVideoSettings:rgbOutputSettings];
    [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    //设置抽象缓存委托和将应用回调的队列
    //[设置代理]**需要实现AVCaptureVideoDataOutputSampleBufferDelegate委托方法**
    [videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
    if ([session canAddOutput:videoDataOutput]) {
        [session addOutput:videoDataOutput];
    } else {
        S2iLog(@"videoDataOutput Error: %@", error);
    }
    //5. 设置Session
    
    
    
    
    [self setExposure: [[S2iConfig sharedS2iConfig] torch]];
    
    if ( [cameraBackDevice lockForConfiguration:NULL] == YES ) {
        S2iLog(@"set subjectAreaChangeMonitoringEnabled");
        cameraBackDevice.subjectAreaChangeMonitoringEnabled = YES;
        [cameraBackDevice unlockForConfiguration];
    }
    
    
    if (_barcode) {
        //创建输出流
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理 在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        [session addOutput:output];
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];        
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(subjectAreaDidChange:)
                                                 name:AVCaptureDeviceSubjectAreaDidChangeNotification
                                               object:cameraBackDevice];
    
}


- (void) subjectAreaDidChange:(NSNotification *)notification {
    //S2iLog(@"subjectAreaDidChange %@", [notification debugDescription]);
}


#pragma mark - 设置拍照变焦
/*****************************************
 *  功能：
 *      设置拍照变焦
 *  参数：
 *      zoomFactor - 变焦倍数
 *****************************************/
- (void)setZoom:(CGFloat)zoomFactor {
    S2iLog(@"setZoom: %f", zoomFactor);
    AVCaptureConnection * stillImageConnection = [S2iCameraManager connectionWithMediaType:AVMediaTypeVideo fromConnections:[stillImageOutput connections]];
    //CGFloat maxScale = stillImageConnection.videoMaxScaleAndCropFactor;
    //S2iLog(@"maxScale: %f", maxScale);
    S2iLog(@"---------zoomFactor:--------%f", zoomFactor);
    //拍照变焦
    [stillImageConnection setVideoScaleAndCropFactor:zoomFactor];
}

#pragma mark 获取后置摄像头
- (AVCaptureDevice *)cameraWithBackPosition {
    //枚举：AVCaptureDevicePositionBack（即：后置摄像头）
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

#pragma mark 遍历IPHONE的视频设备（即：前置或后置摄像头）
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray * devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice * device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

#pragma mark 连接方式
+ (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections {
    for (AVCaptureConnection * connection in connections ) {
        for (AVCaptureInputPort * port in [connection inputPorts] ) {
            if ([[port mediaType] isEqual:mediaType] ) {
                return connection;
            }
        }
    }
    return nil;
}

#pragma mark 停止视频数据
- (void)stopVideoDataOutput {
    if (videoDataOutput) {
        if ([AVCaptureVideoDataOutput instancesRespondToSelector:@selector (connectionWithMediaType:)]) {
            [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:NO];
        } else {
            [[S2iCameraManager connectionWithMediaType:AVMediaTypeVideo fromConnections:[videoDataOutput connections]] setEnabled:NO];
        }
    }
}

#pragma mark - 开启视频数据
- (void)startVideoDataOutput {
    if (videoDataOutput) {
        S2iLog(@"startVideoDataOutput videoDataOutput connectionWithMediaType");
        if ([AVCaptureVideoDataOutput instancesRespondToSelector:@selector (connectionWithMediaType:)]) {
            [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
        } else {
            [[S2iCameraManager connectionWithMediaType:AVMediaTypeVideo fromConnections:[videoDataOutput connections]] setEnabled:YES];
        }
    }
}

#pragma mark - 设置手电筒
- (void)setTorchState:(BOOL)isEnable {
    //取得后背摄像头的手电筒
    if ([[self cameraWithBackPosition] hasFlash]) {
        if ([[self cameraWithBackPosition] lockForConfiguration:nil]) {
            //设置手电筒开关
            if (isEnable) {
                [[self cameraWithBackPosition] setTorchMode:AVCaptureTorchModeOn]; //打开
            } else {
                [[self cameraWithBackPosition] setTorchMode:AVCaptureTorchModeOff]; //关闭
            }
            [[self cameraWithBackPosition] unlockForConfiguration];
        }
    }
    [self setExposure:isEnable];
}

- (BOOL) isTorchOn {
    if ([[self cameraWithBackPosition] hasTorch] && [self cameraWithBackPosition].torchActive) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark 判断摄像头是否支持闪光灯
- (BOOL)hasFlash {
    return [[self cameraWithBackPosition] hasFlash];
}

#pragma mark 获取Session
- (AVCaptureSession *)getSession {
    return session;
}

#pragma mark 获取视频输入
- (AVCaptureDeviceInput *)getVideoInput {
    return videoInput;
}
- (CGFloat) getLensPosition {
    AVCaptureDevice * cameraBackDevice = [self cameraWithBackPosition];
    return cameraBackDevice.lensPosition;
}

#pragma mark - 设置拍照变焦
- (void)setStillImageZoom:(CGFloat)zoomFactor withActiveFormat: (BOOL) isSetActiveFormat {
    //AVCaptureConnection * stillImageConnection = [S2iCameraManager connectionWithMediaType:AVMediaTypeVideo fromConnections:[stillImageOutput connections]];
//    CGFloat maxScale = stillImageConnection.videoMaxScaleAndCropFactor;
//    S2iLog(@"maxScale==%f，  zoomFactor==%f ", maxScale, zoomFactor);
    
    //拍照变焦
    //[stillImageConnection setVideoScaleAndCropFactor:zoomFactor];
    
    AVCaptureDevice * cameraBackDevice = [self cameraWithBackPosition];
    
    if ( [cameraBackDevice lockForConfiguration:NULL] == YES ) {
        //S2iLog([cameraBackDevice.activeFormat debugDescription]);
        if (isSetActiveFormat) {
            AVCaptureDeviceFormat *vFormat = [[cameraBackDevice formats] objectAtIndex:[cameraBackDevice formats].count-1];
            [cameraBackDevice setActiveFormat:vFormat];
            
            [self setCameraActiveFormat];
            S2iLog(@"%@", [cameraBackDevice.activeFormat debugDescription]);
        }
        
        
        [cameraBackDevice setVideoZoomFactor:zoomFactor];
        [cameraBackDevice unlockForConfiguration];
    }
}

- (CGFloat) getCameraCurrentZoom {
    AVCaptureDevice * cameraBackDevice = [self cameraWithBackPosition];
    return cameraBackDevice.videoZoomFactor;
}

- (void) setCameraActiveFormat {
    AVCaptureDevice * cameraBackDevice = [self cameraWithBackPosition];
    if ( [cameraBackDevice lockForConfiguration:NULL] == YES ) {
        //S2iLog([cameraBackDevice.activeFormat debugDescription]);
        if ([cameraBackDevice formats].count > 0) {
            AVCaptureDeviceFormat *vFormat = [[cameraBackDevice formats] objectAtIndex:([cameraBackDevice formats].count-1)];
            S2iLog(@"%@", [vFormat debugDescription]);
            S2iLog(@"%@", [NSString stringWithFormat:@"%f",vFormat.videoMaxZoomFactor]);
            [cameraBackDevice setActiveFormat:vFormat];
        }
        S2iLog(@"%@", [cameraBackDevice.activeFormat debugDescription]);
        [cameraBackDevice unlockForConfiguration];
    }
}

- (void) setExposure: (BOOL) flash {
#if 0
    AVCaptureDevice * cameraBackDevice = [self cameraWithBackPosition];
    
    if ( [cameraBackDevice lockForConfiguration:NULL] == YES ) {
        S2iLog(@"exposure mode: %ld", (long)cameraBackDevice.exposureMode);
        /*
        if ([cameraBackDevice isExposureModeSupported:AVCaptureExposureModeCustom]) {
            [cameraBackDevice setExposureMode:AVCaptureExposureModeCustom];
        }
        S2iLog(@"exposure mode: %ld", (long)cameraBackDevice.exposureMode);
         */
        
        if ([cameraBackDevice isAdjustingExposure]) {
            S2iLog(@"adjusting exposure enabled");
        }
        float bias = flash?-1.0:0;
        [cameraBackDevice setExposureTargetBias: bias completionHandler:^(CMTime syncTime) {
            S2iLog(@"setExposureTargetBias %f", bias);
        }];
        
        [cameraBackDevice unlockForConfiguration];
    }
#endif
#if 0
    AVCaptureDevice * cameraBackDevice = [self cameraWithBackPosition];
    
    if ( [cameraBackDevice lockForConfiguration:NULL] == YES ) {
        S2iLog(@"exposure mode: %ld", (long)cameraBackDevice.exposureMode);
        if ([cameraBackDevice isExposurePointOfInterestSupported]) {
            [cameraBackDevice setExposurePointOfInterest:CGPointMake(0.5, 0.5)];
        }
        
         if ([cameraBackDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
             [cameraBackDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
         }
         S2iLog(@"exposure mode: %ld", (long)cameraBackDevice.exposureMode);
        [cameraBackDevice unlockForConfiguration];
    }
#endif
}

- (void) setFocusPoint: (CGPoint) focusPoint {
    AVCaptureDevice * cameraBackDevice = [self cameraWithBackPosition];
    if (cameraBackDevice.focusPointOfInterestSupported) {
        S2iLog(@"focusPointOfInterestSupported TRUE");
        if ( [cameraBackDevice lockForConfiguration:NULL] == YES ) {
            [cameraBackDevice setFocusPointOfInterest: focusPoint];
            [cameraBackDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [cameraBackDevice unlockForConfiguration];
        }
    }
}

#pragma mark 拍照
- (void)captureStillImage {
#if !TARGET_IPHONE_SIMULATOR
    //1. 需要获得扑捉连接，并确保使用了纵向来扑捉图像
    AVCaptureConnection * stillImageConnection = [S2iCameraManager connectionWithMediaType:AVMediaTypeVideo fromConnections:[stillImageOutput connections]];
    
    //2. 然后运行 captureStillImageAsynchronouslyFromConnection 方法，
    //      并提供一个代码块，当静态图像扑捉完成时会调用它。
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                                  completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
         //3. 扑捉完成后，首先检测是否成功；如不成功则输出错误日志。
         if (imageDataSampleBuffer != NULL) {
             //4. 如果扑捉成功，从缓存中提取图像。---(执行代理的方法)
             if ([_delegate respondsToSelector:@selector(cameraManagerWithStillImage:)]) {
                 [_delegate cameraManagerWithStillImage:imageDataSampleBuffer];
             }
         } else {
             S2iLog(@"captureStillImage Error %@", error);
         }
     }];
#endif
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

#pragma mark 视频流回调函数
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    if (videoDataOutput) {
        @autoreleasepool {
            //视频流代理方法
            if ([_delegate respondsToSelector:@selector(cameraManagerWithVideoOutput:)]) {
                [_delegate cameraManagerWithVideoOutput:sampleBuffer];
            }
        }
    }
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate

#pragma mark barcode
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        S2iLog(@"%@",metadataObject.stringValue);
        if (_barcode) {
            //相同的码值 是否还能扫码
//            if (metadataObject.stringValue && [metadataObject.stringValue compare:barcodeString] != NSOrderedSame) {
            if (metadataObject.stringValue ) {
                barcodeString = metadataObject.stringValue;
                [_delegate cameraManagerWithBarcodeResult:metadataObject.stringValue];
            } else {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    barcodeString = metadataObject.stringValue;
//                    [_delegate cameraManagerWithBarcodeResult:metadataObject.stringValue];
//                });
                S2iLog(@"barcode no changed");
            }
        }
    }
}
@end
