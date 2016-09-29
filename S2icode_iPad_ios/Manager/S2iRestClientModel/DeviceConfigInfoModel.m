//
//  DeviceConfigInfoModel.m
//  S2iPhone
//
//  Created by Pai Peng on 01/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import "DeviceConfigInfoModel.h"

@implementation DeviceConfigInfoModel

//@synthesize ReflectDiff;

- (NSDictionary*) convertToDictionary {
    
    NSDictionary *queryParams = @{@"DeviceId": _DeviceId,
                                  @"DPI2000RangeMin": _DPI2000RangeMin,
                                  @"DPI2000RangeMax": _DPI2000RangeMax,
                                  @"DPI800RangeMin": _DPI800RangeMin,
                                  @"DPI800RangeMax": _DPI800RangeMax,
                                  @"Zoom": _Zoom,
                                  @"MinZoom": _MinZoom?_MinZoom:[NSNumber numberWithInt:0],
                                  @"MaxZoom": _MaxZoom?_MaxZoom:[NSNumber numberWithInt:0],
                                  @"DPI2000FocusBoxWidth": _DPI2000FocusBoxWidth,
                                  @"DPI2000FocusBoxHeight": _DPI2000FocusBoxHeight,
                                  @"DPI800FocusBoxWidth": _DPI800FocusBoxWidth,
                                  @"DPI800FocusBoxHeight": _DPI800FocusBoxHeight,
                                  @"PhotoSizeWidth": _PhotoSizeWidth,
                                  @"PhotoSizeHeight": _PhotoSizeHeight,
                                  @"PreviewSizeWidth": _PreviewSizeWidth,
                                  @"PreviewSizeHeight": _PreviewSizeHeight,
                                  @"PositionErrorMargin": _PositionErrorMargin,
                                  @"AutoPhotoMinTimeInterval": _AutoPhotoMinTimeInterval,
                                  @"AutoFocusTimeInterval": _AutoFocusTimeInterval,
                                  @"FocusMode": _FocusMode,
                                  @"EMetricThreshold": _EMetricThreshold,
                                  @"MinDistToThreshold": _MinDistToThreshold,
                                  @"MinDiffBW": _MinDiffBW,
                                  @"MaxQuotAmplitudeBW": _MaxQuotAmplitudeBW,
                                  @"MinEdgeEnergy": _MinEdgeEnergy,
                                  @"JpegCompress": _JpegCompress,
                                  @"S2iPicWidth": _S2iPicWidth,
                                  @"S2iPicHeight": _S2iPicHeight,
                                  @"S2iPicBorder": _S2iPicBorder,
                                  @"ReflectDiff": _ReflectDiff,
                                  @"DetectCropImageWidthScale": _DetectCropImageWidthScale,
                                  @"DetectCropImageHeightScale": _DetectCropImageHeightScale,
                                  @"UploadFullImageThumbnail": [NSNumber numberWithBool:_UploadFullImageThumbnail],
                                  @"ThumbnailImageWidth": _ThumbnailImageWidth,
                                  @"ThumbnailImageHeight": _ThumbnailImageHeight,
                                  @"ThumbnailImageJpegCompress": _ThumbnailImageJpegCompress,
                                  @"DisableDecode": [NSNumber numberWithBool:_DisableDecode],
                                  @"ForceLogin": [NSNumber numberWithBool:_ForceLogin]
    
                                  };
    return queryParams;
}

- (void) initWithDictionary: (NSDictionary*) dict {
    if (dict) {
        
        _AutoFocusTimeInterval = [dict valueForKey: @"AutoFocusTimeInterval"];
        _AutoPhotoMinTimeInterval = [dict valueForKey: @"AutoPhotoMinTimeInterval"];
        _DPI2000FocusBoxHeight = [dict valueForKey: @"DPI2000FocusBoxHeight"];
        _DPI2000FocusBoxWidth = [dict valueForKey: @"DPI2000FocusBoxWidth"];
        _DPI2000RangeMax = [dict valueForKey: @"DPI2000RangeMax"];
        _DPI2000RangeMin = [dict valueForKey: @"DPI2000RangeMin"];
        _DPI800FocusBoxHeight = [dict valueForKey: @"DPI800FocusBoxHeight"];
        _DPI800FocusBoxWidth = [dict valueForKey: @"DPI800FocusBoxWidth"];
        _DPI800RangeMax = [dict valueForKey: @"DPI800RangeMax"];
        _DPI800RangeMin = [dict valueForKey: @"DPI800RangeMin"];
        _DetectCropImageHeightScale = [dict valueForKey: @"DetectCropImageHeightScale"];
        _DetectCropImageWidthScale = [dict valueForKey: @"DetectCropImageWidthScale"];
        _DeviceId = [dict valueForKey: @"DeviceId"];
        _DisableDecode = [dict valueForKey: @"DisableDecode"]?[((NSNumber*)[dict valueForKey: @"DisableDecode"]) boolValue]:NO;
        _EMetricThreshold = [dict objectForKey:@"EMetricThreshold"];
        _FocusMode = [dict valueForKey: @"FocusMode"];
        _ForceLogin = [dict valueForKey: @"ForceLogin"]?[((NSNumber*)[dict valueForKey: @"ForceLogin"]) boolValue]:NO;
        _JpegCompress = [dict valueForKey: @"JpegCompress"];
        _MaxQuotAmplitudeBW = [dict valueForKey: @"MaxQuotAmplitudeBW"];
        _MinDiffBW = [dict valueForKey: @"MinDiffBW"];
        _MinDistToThreshold = [dict valueForKey: @"MinDistToThreshold"];
        _MinEdgeEnergy = [dict valueForKey: @"MinEdgeEnergy"];
        
        _PhotoSizeHeight = [dict valueForKey: @"PhotoSizeHeight"];
        _PhotoSizeWidth = [dict valueForKey: @"PhotoSizeWidth"];
        _PositionErrorMargin = [dict valueForKey: @"PositionErrorMargin"];
        _PreviewSizeHeight = [dict valueForKey: @"PreviewSizeHeight"];
        _PreviewSizeWidth = [dict valueForKey: @"PreviewSizeWidth"];
        _ReflectDiff = [dict valueForKey: @"ReflectDiff"];
        _S2iPicBorder = [dict valueForKey: @"S2iPicBorder"];
        _S2iPicHeight = [dict valueForKey: @"S2iPicHeight"];
        _S2iPicWidth = [dict valueForKey: @"S2iPicWidth"];
        _ThumbnailImageHeight = [dict valueForKey: @"ThumbnailImageHeight"];
        _ThumbnailImageJpegCompress = [dict valueForKey: @"ThumbnailImageJpegCompress"];
        _ThumbnailImageWidth = [dict valueForKey: @"ThumbnailImageWidth"];
        _UploadFullImageThumbnail = [dict valueForKey: @"UploadFullImageThumbnail"]?[((NSNumber*)[dict valueForKey: @"UploadFullImageThumbnail"]) boolValue]:NO;
        _Zoom = [dict valueForKey: @"Zoom"];
        _MinZoom = [dict valueForKey: @"MinZoom"];
        _MaxZoom = [dict valueForKey: @"MaxZoom"];
    }
}

@end
