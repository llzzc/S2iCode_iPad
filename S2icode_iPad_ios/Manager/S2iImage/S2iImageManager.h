//
//  S2iImageManager.h
//  S2iPhone
//
//  Created by txm on 14/12/19.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
/*
    描述：图像处理管理类
 */

#import <Foundation/Foundation.h>
#import <CoreMedia/CMSampleBuffer.h>
#include "detect_param.h"

@interface S2iImageManager : NSObject


/**
 *  CMSampleBufferRef类型 转 UIImage类型
 *
 *  @param sampleBuffer CMSampleBufferRef类型数据
 *
 *  @return UIImage类型数据
 */
+ (UIImage *)convertCMSampleBufferRef2UIImage:(CMSampleBufferRef)sampleBuffer;



/**
 *  UIImage类型 转 IplImage类型
 *
 *  @param image UIImage类型数据
 *
 *  @return IplImage类型数据
 */
//+ (IplImage *)convertUIImage2IplImage:(UIImage *)image;




/**
 *  把CMSampleBufferRef类型转成UIImage类型
 *
 *  @param sampleBuffer CMSampleBufferRef类型数据
 *
 *  @return UIImage类型
 */
+ (UIImage *)convertCMBuf2UIImage:(CMSampleBufferRef)sampleBuffer withRotation:(BOOL) isRotation;



/**
 *  剪切图片
 *
 *  [注意]：当调用此函数后，必须释放内存
 *
 *  @param img  原图数据
 *  @param rect 目标矩形参数值
 *
 *  @return 目标图像数据
 */
+ (UIImage *)getSubImageFrom:(UIImage *)img WithRect:(CGRect)rect;




/**
 *  旋转图像
 *
 *  @param image   图像数据
 *  @param degrees 旋转度数
 *
 *  @return 图像数据
 */
+ (UIImage *)rotateImage:(UIImage *)image byDegree:(CGFloat)degrees;




/**
 *  调整图像大小(等比缩小)
 *
 *  @param image   原图像的数据
 *  @param newSize 新图像的大小
 *
 *  @return 图像数据
 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;






/**
 *  图像转灰度
 *
 *  @param i   UIImage类型图像数据
 *
 *  @return 灰度图像
 */
+ (UIImage *)convertToGreyscale2:(UIImage *)i;





/**
 *  创建一个上传的图像（640*640）
 *
 *  @param srcImage    原图图像
 *  @param imageSize   上传图像大小（640*640）
 *  @param color       颜色
 *
 *  @return 灰度图像
 */
+ (UIImage *)canvasImage:(UIImage *)srcImage
                  toSize:(CGSize)imageSize
               withColor:(UIColor *)color;

+ (UIImage*) grayishImage: (UIImage*) inputImage;


/**
 *	@brief	浏览头像
 *
 *	@param 	oldImageView 	头像所在的imageView
 */
+(void)showImage:(UIImageView*)avatarImageView;

//+ (DetectResult*) s2iDetect: (UIImage*) image;
+ (void) s2iDetect: (UIImage*) image withDetectResult: (DetectResult*) result;

+ (UIImage*) cropS2iDetectedImage: (UIImage*) image withDetectResult: (DetectResult*) detectResult withRotate: (NSInteger) rotateDegree;
+ (UIImage*) maskImage:(UIImage *) image withMask:(UIImage *) mask;
+(UIImage*) rotate:(UIImage*) src withOrientatin:(UIImageOrientation) orientation;
@end
