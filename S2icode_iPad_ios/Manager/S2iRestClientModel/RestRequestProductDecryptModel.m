//
//  RestRequestProductDecryptModel.m
//  S2iPhone
//
//  Created by Pai Peng on 02/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import "RestRequestProductDecryptModel.h"
#import "DeviceConfigInfoModel.h"
#import "S2iClientManager.h"
#import "S2iImageManager.h"





static char encodingTable[64] = {
    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
    'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
    'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
    'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/' };


@implementation NSData(Base64)

#pragma mark - 重写，图像数据类型转换（NSData 转 base64Binary类型）
- (NSString *)base64EncodingWithLineLength:(unsigned int)lineLength
{
    const unsigned char	*bytes = (const unsigned char*)[self bytes];
    NSMutableString *result = [NSMutableString stringWithCapacity:[self length]];
    unsigned long ixtext = 0;
    unsigned long lentext = [self length];
    long ctremaining = 0;
    unsigned char inbuf[3], outbuf[4];
    short i = 0;
    short charsonline = 0, ctcopy = 0;
    unsigned long ix = 0;
    
    while( YES )
    {
        ctremaining = lentext - ixtext;
        if( ctremaining <= 0 ) break;
        
        for( i = 0; i < 3; i++ )
        {
            ix = ixtext + i;
            if( ix < lentext ) inbuf[i] = bytes[ix];
            else inbuf [i] = 0;
        }
        
        outbuf [0] = (inbuf [0] & 0xFC) >> 2;
        outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
        outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
        outbuf [3] = inbuf [2] & 0x3F;
        ctcopy = 4;
        
        switch( ctremaining )
        {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for( i = 0; i < ctcopy; i++ )
            [result appendFormat:@"%c", encodingTable[outbuf[i]]];
        
        for( i = ctcopy; i < 4; i++ )
            [result appendFormat:@"%c",'='];
        
        ixtext += 3;
        charsonline += 4;
        
        if( lineLength > 0 )
        {
            if (charsonline >= lineLength)
            {
                charsonline = 0;
                [result appendString:@"\n"];
            }
        }
    }
    return result;
}

@end


@implementation RestRequestProductDecryptModel


- (id) init {
    self = [super init];
    
    NSInteger nDeviceId = [S2iConfig sharedS2iConfig].deviceId;
    _DeviceId = [NSNumber numberWithInteger: nDeviceId];
    _Lupe = [NSNumber numberWithBool:[S2iConfig sharedS2iConfig].manualZoom];
    _Zoom = [NSNumber numberWithInteger:roundf( [S2iConfig sharedS2iConfig].zoom*100.0)/100.0];
    _Dpi = [NSNumber numberWithInteger:2000];
    _Address = @"";
    return self;
}

- (void) setGPSLatitude: (CGFloat) latitude longitude: (CGFloat) longitude {
    _Latitude = [NSNumber numberWithFloat:latitude];
    _Longitude = [NSNumber numberWithFloat:longitude];
}

- (void) setImage: (UIImage*) image {
    if (image) {
        DeviceConfigInfoModel* deviceConfigInfoModel = [S2iClientManager sharedS2iClientManager].getDeviceConfigInfo;
        // TODO resize to small image
        UIImage* uploadImage = [S2iImageManager imageWithImage:image scaledToSize:CGSizeMake([deviceConfigInfoModel.S2iPicWidth intValue], [deviceConfigInfoModel.S2iPicHeight intValue])];
        NSData * imageData = UIImageJPEGRepresentation(uploadImage, [deviceConfigInfoModel.JpegCompress intValue]/100.0);
        if (imageData) {
            S2iLog(@"image size %ld", (unsigned long)imageData.length);
            //图像类型装换（NSData 转 base64Binary类型）
            _Base64StrData = [imageData base64EncodingWithLineLength:0];
        } else {
            S2iLog(@"解码图像无效！");
        }
    }
}

- (void) setDetectResult: (DetectResult*) detectResult {
    if (detectResult) {
        
        _EMetricThreshold = [NSNumber numberWithFloat:detectResult->EMetricThreshold];
        _MinDistToThreshold = [NSNumber numberWithInt:detectResult->MinDistToThreshold];
        _MinDiffBW = [NSNumber numberWithInt:detectResult->MinDiffBW];
        _MaxQuotAmplitudeBW = [NSNumber numberWithInt:detectResult->MaxQuotAmplitudeBW];
        _MinEdgeEnergy = [NSNumber numberWithInt:detectResult->MinEdgeEnergy];
        
        NSLog(@"最近一次赋值：：：%@,%@,%@,%@,%@",_EMetricThreshold,_MinDistToThreshold,_MinDiffBW,_MaxQuotAmplitudeBW,_MinEdgeEnergy);
    }
}

- (NSDictionary*) convertToDictionary {
    NSMutableDictionary* d = [[NSMutableDictionary alloc] initWithDictionary:[super convertToDictionary]];
    NSString* systemVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本wqe : %@", systemVersion);
    [d addEntriesFromDictionary: @{
                                   @"DeviceId": _DeviceId,
                                   @"Longitude": _Longitude,
                                   @"Latitude": _Latitude,
                                   @"Address": _Address,
                                   @"Lupe": _Lupe,
                                   @"Zoom": _Zoom,
                                   @"Dpi": _Dpi,
                                   @"Base64StrData": _Base64StrData,
                                   @"EMetricThreshold": _EMetricThreshold?_EMetricThreshold:[NSNumber numberWithInteger:0],
                                   @"MinDistToThreshold": _MinDistToThreshold?_MinDistToThreshold:[NSNumber numberWithInteger:0],
                                   @"MinDiffBW": _MinDiffBW?_MinDiffBW:[NSNumber numberWithInteger:0],
                                   @"MaxQuotAmplitudeBW": _MaxQuotAmplitudeBW?_MaxQuotAmplitudeBW:[NSNumber numberWithInteger:0],
                                   @"MinEdgeEnergy": _MinEdgeEnergy?_MinEdgeEnergy:[NSNumber numberWithInteger:0],
                                   @"SoftwareName": [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey],
                                   @"SoftwareVersion": [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                                   @"UDID": [S2iConfig sharedS2iConfig].UUID,
                                   @"SystemVersion":systemVersion
                                   }];
    return d;
}
@end
