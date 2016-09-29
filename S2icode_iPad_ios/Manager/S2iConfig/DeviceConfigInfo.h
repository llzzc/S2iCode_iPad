//
//  DeviceConfigInfo.h
//  S2iPhone
//
//  Created by Pai Peng on 21/04/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#ifndef DeviceConfigInfo_h
#define DeviceConfigInfo_h

typedef struct _deviceConfigInfo{
    int AutoFocusTimeInterval;
    int AutoPhotoMinTimeInterval;
    int DPI2000FocusBoxHeight;
    int DPI2000FocusBoxWidth;
    int DPI2000RangeMax;
    int DPI2000RangeMin;
    int DPI800FocusBoxHeight;
    int DPI800FocusBoxWidth;
    int DPI800RangeMax;
    int DPI800RangeMin;
    float DetectCropImageHeightScale;
    float DetectCropImageWidthScale;
    int DeviceId;
    int DisableDecode;
    float EMetricThreshold;
    int FocusMode;
    int ForceLogin;
    int JpegCompress;
    int MaxQuotAmplitudeBW;
    int MinDiffBW;
    int MinDistToThreshold;
    int MinEdgeEnergy;
    int PhotoSizeHeight;
    int PhotoSizeWidth;
    int PositionErrorMargin;
    int PreviewSizeHeight;
    int PreviewSizeWidth;
    int ReflectDiff;
    int S2iPicBorder;
    int S2iPicHeight;
    int S2iPicWidth;
    int ThumbnailImageHeight;
    int ThumbnailImageJpegCompress;
    int ThumbnailImageWidth;
    int UploadFullImageThumbnail;
    int Zoom;
    float minZoom;
    float maxZoom;
} DeviceConfigInfo;
#endif /* DeviceConfigInfo_h */
