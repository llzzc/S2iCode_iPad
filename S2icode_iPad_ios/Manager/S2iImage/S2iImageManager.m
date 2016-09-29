//
//  S2iImageManager.m
//  S2iPhone
//
//  Created by txm on 14/12/19.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iImageManager.h"
#include "test_images.h"
#include "imageToCmatrix.h"
//#include "s2iutils.h"
//#include "rw_bmp.h"


#import "DeviceConfigInfoModel.h"

@implementation S2iImageManager


static CGRect oldframe;

#pragma mark - CMSampleBufferRef类型 转 UIImage类型
+ (UIImage *)convertCMSampleBufferRef2UIImage:(CMSampleBufferRef)sampleBuffer;
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}




/*
#pragma mark - UIImage类型 转 IPlImage类型
+ (IplImage *)convertUIImage2IplImage:(UIImage *)image
{
    if(image == nil)
    {
        return nil;
    }
    //Getting CGImage from UIImage
    //S2iLog(@"CreateIplImageFromUIImage: size: %lf-%lf", image.size.width, image.size.height);
    CGImageRef imageRef = image.CGImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Creating temporal IplImage for drawing
    IplImage *iplimage = cvCreateImage(cvSize(image.size.width,image.size.height), IPL_DEPTH_8U, 4);
    // Creating CGContext for temporal IplImage
    CGContextRef contextRef = CGBitmapContextCreate(
                                                    iplimage->imageData,
                                                    iplimage->width,
                                                    iplimage->height,
                                                    iplimage->depth,
                                                    iplimage->widthStep,
                                                    colorSpace,
                                                    kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    // Drawing CGImage to CGContext
    CGContextDrawImage(contextRef,
                       CGRectMake(0, 0, image.size.width, image.size.height),
                       imageRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    //S2iLog(@"IplImage: size: %d-%d", iplimage->width, iplimage->height);
    //return iplimage;
    
    // Creating result IplImage
    IplImage * ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplimage, ret, CV_RGBA2BGR);
    cvReleaseImage(&iplimage);
    return ret;
}
*/




#pragma mark - 把CMSampleBufferRef类型转成UIImage类型
/********************************************************************
 *  功能：
 *      把CMSampleBufferRef类型转成UIImage类型
 *  参数：
 *      sampleBuffer - CMSampleBufferRef类型数据
 ********************************************************************/
+ (UIImage *)convertCMBuf2UIImage:(CMSampleBufferRef)sampleBuffer withRotation:(BOOL) isRotation
{
    UIImage *image = nil;
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    if (sampleBuffer)
    {
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        if (imageBuffer)
        {
            // Lock the base address of the pixel buffer
            //锁定pixel buffer的基地址
            CVPixelBufferLockBaseAddress(imageBuffer, 0);
            //通过imageBuffer，得到ciImage
            CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
            //CGImageRef类型图像数据
            CGImageRef ref = [[CIContext contextWithOptions:nil] createCGImage:ciImage fromRect:ciImage.extent];
            
            if (isRotation) {
                //set the image rotation!!!
                //设置图像反转
                //得到UIImage类型图像数据
                image = [UIImage imageWithCGImage:ref scale:1.0 orientation:UIImageOrientationUp];
                
                
            } else {
                image = [UIImage imageWithCGImage:ref];
            }
            CGImageRelease(ref);
            // release memory
            //解锁pixel buffer
            CVPixelBufferUnlockBaseAddress(imageBuffer, 0);

        }
    }
    return image;
}





#pragma mark - 剪切图片
/***********************************************
 *  功能：
 *      剪切图片
 *  参数；
 *      img - 原图数据
 *      rect - 目标矩形参数值
 *  返回：
 *      目标图像数据
 *
 *  [注]：
 *      当调用此函数后，必须释放内存。
 *
 ***********************************************/
+ (UIImage *)getSubImageFrom:(UIImage *)img WithRect:(CGRect)rect
{
    if(rect.size.height<=0 || rect.size.width<=0)
    {
        return nil;
    }
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // translated rectangle for drawing sub image
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    // draw image
    [img drawInRect:drawRect];
    // grab image
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext(); // autorelease, must in main thread
    UIGraphicsEndImageContext();
    return subImage;
}





#pragma mark - 旋转图像
/******************************************************************
 *  功能：
 *      旋转图像
 *  参数：
 *      image -  图像数据
 *      degrees - 旋转度数
 ******************************************************************/
+ (UIImage *)rotateImage:(UIImage *)image byDegree:(CGFloat)degrees
{
    CGFloat rads = M_PI * degrees / 180;
    float newSide = MAX([image size].width, [image size].height);
    float shortSide = MIN([image size].width, [image size].height);
    
    float width =([image size].width>[image size].height)?shortSide:newSide;
    float height =([image size].width>[image size].height)?newSide:shortSide;
    
    CGSize size =  CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(ctx, size.width/2, size.height/2);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextRotateCTM(ctx, rads);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(),
                       CGRectMake(-[image size].width/2,
                                  -[image size].height/2,
                                  image.size.width,
                                  image.size.height),
                       image.CGImage);
    
    UIImage * i = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;
}




#pragma mark - 调整图像大小(等比缩小)
/****************************************************************************
 *  功能：
 *      调整图像大小(等比缩小)
 *  参数：
 *      image - 原图像的数据
 *      newSize - 新图像的大小
 *  返回：
 *      调整后的图像数据（新图像）
 ****************************************************************************/
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



#pragma mark -  图像转灰度
/***********************************************
 *  功能：
 *      图像转灰度
 *  参数；
 *      i - UIImage类型图像数据
 *  返回：
 *      灰度图像
 ***********************************************/
+ (UIImage *)convertToGreyscale2:(UIImage *)i
{
    int m_width = i.size.width;
    int m_height = i.size.height;
    
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width, colorSpace, kCGImageAlphaNone);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    
    // image to context(rgbImage)
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [i CGImage]);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    if (rgbImage)
    {
        free(rgbImage);
    }
    return resultUIImage;
}

// Transform the image in grayscale.
+ (UIImage*) grayishImage: (UIImage*) inputImage {
    
    // Create a graphic context.
    UIGraphicsBeginImageContextWithOptions(inputImage.size, YES, 1.0);
    CGRect imageRect = CGRectMake(0, 0, inputImage.size.width, inputImage.size.height);
    
    // Draw the image with the luminosity blend mode.
    // On top of a white background, this will give a black and white image.
    [inputImage drawInRect:imageRect blendMode:kCGBlendModeLuminosity alpha:1.0];
    
    // Get the resulting image.
    UIImage *filteredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return filteredImage;
    
}


#pragma mark - 创建一个上传的图像（640*640）
+ (UIImage *)canvasImage:(UIImage *)srcImage
                  toSize:(CGSize)imageSize
               withColor:(UIColor *)color
{
    UIImage* canvasImage = nil;
    if (srcImage && (srcImage.size.width < imageSize.width && srcImage.size.height < imageSize.height))
    {
        const CGFloat margin_x = (imageSize.width-srcImage.size.width)/2.0;
        const CGFloat margin_y = (imageSize.height-srcImage.size.height)/2.0;
        CGRect aRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
        UIGraphicsBeginImageContext(aRect.size);
        // set background color
        if (color)
        {
            [color setFill];
        }
        else
        {
            [[UIColor whiteColor] setFill];
        }
        [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, imageSize.width, imageSize.height)] fill];
        CGRect rect = CGRectMake(margin_x, margin_y, srcImage.size.width, srcImage.size.height);
        [srcImage drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
        // Create the new UIImage from the context
        canvasImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return canvasImage;
}


+(void)showImage:(UIImageView *)avatarImageView
{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}


+ (void) s2iDetect: (UIImage*) image withDetectResult: (DetectResult*) result {
    //UIImage* image2 = [S2iImageManager rotateImage:image byDegree:-90];
    cmatrix* matrix = convertToCmatrix(image);
    

    DetectParam detectParam;
    
    DeviceConfigInfoModel* deviceConfigInfo = [[S2iClientManager sharedS2iClientManager] getDeviceConfigInfo];
    if (deviceConfigInfo) {
       
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
        
        detectParam.EMetricThreshold = eMetricThreshold;
        detectParam.MinDistToThreshold =minDistToThreshold;// MINDIST_TO_THRESHOLD;
        detectParam.MinDiffBW = minDiffBW;// MINDIFF_BLACK_WHITE;
        detectParam.MaxQuotAmplitudeBW = maxQuotAmplitudeBW;//MAXQUOT_AMPLITUDE_BW;
        detectParam.MinEdgeEnergy = minEdgeEnergy;// MINIMUM_EDGE_ENERGY;
    }
    //DetectResult result;// = (DetectResult*) malloc(sizeof(DetectResult));
    //memset(result, 0, sizeof(DetectResult));
    int ret = detectImage(matrix, detectParam, result);
    //消除黄色警告
    NSLog(@"%d",ret);
    S2iLog(@"Otsu intensity threshold = %d",result->level);
    S2iLog(@"Efectiveness metric = %4.3f\n",result->metric);
//    [overlayView setTestLabelText:[NSString stringWithFormat:@"s2i %d-%4.3f", result->level, result->metric]];
    free_cmatrix(matrix);
    
    S2iLog(@"codetype %d", result->codeType);
    if (result->codeType != 24) {
        result->detected = FALSE;
    }
    //return result;
}
+ (UIImage*) cropS2iDetectedImage: (UIImage*) image withDetectResult: (DetectResult*) detectResult withRotate: (NSInteger) rotateDegree {
    CGRect detectedFrame = CGRectMake(detectResult->x1, detectResult->y1, detectResult->x2-detectResult->x1, detectResult->y2-detectResult->y1);
    //CGFloat frameRate = detectedFrame.size.height/image.size.height;
    DeviceConfigInfoModel* deviceConfigInfo = [[S2iClientManager sharedS2iClientManager] getDeviceConfigInfo];
    UIImage* subImage = [S2iImageManager getSubImageFrom:image WithRect:[S2iTool expandedDetectedFrameRect:detectedFrame withBorder:[deviceConfigInfo.S2iPicBorder intValue]]];
    if (rotateDegree != 0) {
        // rotate to right
        UIImage* rotateSubImage = [S2iImageManager rotateImage:subImage  byDegree: rotateDegree];
        //[[S2iClientManager sharedS2iClientManager] saveS2iImage:subImage];
        // convert to gray
        return [S2iImageManager convertToGreyscale2:rotateSubImage];
    } else {
        return [S2iImageManager convertToGreyscale2:subImage];
    }
}


+ (UIImage*) maskImage:(UIImage *) image withMask:(UIImage *) mask {
    CGImageRef imageReference = image.CGImage;
    CGImageRef maskReference = mask.CGImage;
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                             CGImageGetHeight(maskReference),
                                             CGImageGetBitsPerComponent(maskReference),
                                             CGImageGetBitsPerPixel(maskReference),
                                             CGImageGetBytesPerRow(maskReference),
                                             CGImageGetDataProvider(maskReference),
                                             NULL, // Decode is null
                                             YES // Should interpolate
                                             );
    
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    CGImageRelease(imageMask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
    CGImageRelease(maskedReference);
    
    return maskedImage;
}

static inline double radians (double degrees) {return degrees * M_PI/180;}
+(UIImage*) rotate:(UIImage*) src withOrientatin:(UIImageOrientation) orientation
{
    UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, radians(90));
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, radians(-90));
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, radians(90));
    }
    
    [src drawAtPoint:CGPointMake(0, 0)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
