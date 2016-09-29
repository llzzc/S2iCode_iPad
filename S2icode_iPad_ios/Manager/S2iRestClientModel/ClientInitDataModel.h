//
//  ClientInitDataModel.h
//  S2iPhone
//
//  Created by Pai Peng on 01/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceConfigInfoModel.h"
#import "SoftwareVersionModel.h"
#import "SlidePictureModel.h"

@interface ClientInitDataModel : NSObject


@property (nonatomic, strong) NSArray *SlidePictures;
@property (nonatomic, strong) DeviceConfigInfoModel *DeviceConfigInfo;
@property (nonatomic, strong) SoftwareVersionModel *SoftwareVersion;
@property (nonatomic, strong) NSArray *QRWhiteUrls;


- (NSDictionary*) convertToDictionary;

@end
