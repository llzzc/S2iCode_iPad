//
//  DeviceConfigInfoModel.h
//  S2iPhone
//
//  Created by Pai Peng on 01/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceConfigInfoModel : NSObject



@property (nonatomic, copy) NSNumber *DeviceId;
@property (nonatomic, copy) NSNumber *DPI2000RangeMin;
@property (nonatomic, copy) NSNumber *DPI2000RangeMax;
@property (nonatomic, copy) NSNumber *DPI800RangeMin;
@property (nonatomic, copy) NSNumber *DPI800RangeMax;
@property (nonatomic, copy) NSNumber *Zoom;
@property (nonatomic, copy) NSNumber *DPI2000FocusBoxWidth;
@property (nonatomic, copy) NSNumber *DPI2000FocusBoxHeight;
@property (nonatomic, copy) NSNumber *DPI800FocusBoxWidth;
@property (nonatomic, copy) NSNumber *DPI800FocusBoxHeight;

@property (nonatomic, copy) NSNumber *PhotoSizeWidth;
@property (nonatomic, copy) NSNumber *PhotoSizeHeight;
@property (nonatomic, copy) NSNumber *PreviewSizeWidth;
@property (nonatomic, copy) NSNumber *PreviewSizeHeight;
@property (nonatomic, copy) NSNumber *PositionErrorMargin;
@property (nonatomic, copy) NSNumber *AutoPhotoMinTimeInterval;
@property (nonatomic, copy) NSNumber *AutoFocusTimeInterval;

@property (nonatomic, copy) NSNumber *FocusMode;
@property (nonatomic, copy) NSNumber *EMetricThreshold;
@property (nonatomic, copy) NSNumber *MinDistToThreshold;
@property (nonatomic, copy) NSNumber *MinDiffBW;
@property (nonatomic, copy) NSNumber *MaxQuotAmplitudeBW;
@property (nonatomic, copy) NSNumber *MinEdgeEnergy;
@property (nonatomic, copy) NSNumber *JpegCompress;
@property (nonatomic, copy) NSNumber *S2iPicWidth;
@property (nonatomic, copy) NSNumber *S2iPicHeight;

@property (nonatomic, copy) NSNumber *S2iPicBorder;
@property (nonatomic, copy) NSNumber *ReflectDiff;
@property (nonatomic, copy) NSNumber *DetectCropImageWidthScale;
@property (nonatomic, copy) NSNumber *DetectCropImageHeightScale;
@property (nonatomic, assign) BOOL UploadFullImageThumbnail;
@property (nonatomic, copy) NSNumber *ThumbnailImageWidth;
@property (nonatomic, copy) NSNumber *ThumbnailImageHeight;
@property (nonatomic, copy) NSNumber *ThumbnailImageJpegCompress;
@property (nonatomic, assign) BOOL DisableDecode;
@property (nonatomic, assign) BOOL ForceLogin;

@property (nonatomic, copy) NSNumber *MinZoom;
@property (nonatomic, copy) NSNumber *MaxZoom;
//"DeviceId":857,"DPI2000RangeMin":20,"DPI2000RangeMax":34,"DPI800RangeMin":35,"DPI800RangeMax":55,"Zoom":0,"DPI2000FocusBoxWidth":400,"DPI2000FocusBoxHeight":310,"DPI800FocusBoxWidth":0,"DPI800FocusBoxHeight":0,"PhotoSizeWidth":0,"PhotoSizeHeight":0,"PreviewSizeWidth":0,"PreviewSizeHeight":0,"PositionErrorMargin":50,"AutoPhotoMinTimeInterval":10,"AutoFocusTimeInterval":4000,"FocusMode":0,"EMetricThreshold":0.5,"MinDistToThreshold":0,"MinDiffBW":30,"MaxQuotAmplitudeBW":20,"MinEdgeEnergy":3,"JpegCompress":50,"S2iPicWidth":640,"S2iPicHeight":640,"S2iPicBorder":80,"ReflectDiff":10,"DetectCropImageWidthScale":0.99,"DetectCropImageHeightScale":0.85,"UploadFullImageThumbnail":false,"ThumbnailImageWidth":0,"ThumbnailImageHeight":0,"ThumbnailImageJpegCompress":0,"DisableDecode":false,"ForceLogin":false


- (NSDictionary*) convertToDictionary;
- (void) initWithDictionary: (NSDictionary*) dict;
@end
