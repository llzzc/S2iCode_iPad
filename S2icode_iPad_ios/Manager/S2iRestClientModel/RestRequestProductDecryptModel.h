//
//  RestRequestProductDecryptModel.h
//  S2iPhone
//
//  Created by Pai Peng on 02/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import "RestRequestBaseModel.h"

@interface RestRequestProductDecryptModel : RestRequestBaseModel

@property (nonatomic, strong) NSNumber *DeviceId;
@property (nonatomic, strong) NSNumber *Longitude;
@property (nonatomic, strong) NSNumber *Latitude;
@property (nonatomic, strong) NSString *Address;
@property (nonatomic, strong) NSNumber *Lupe;
@property (nonatomic, strong) NSNumber *Zoom;
@property (nonatomic, strong) NSNumber *Dpi;

@property (nonatomic, strong) NSNumber* EMetricThreshold;
@property (nonatomic, strong) NSNumber* MinDistToThreshold;
@property (nonatomic, strong) NSNumber* MinDiffBW;
@property (nonatomic, strong) NSNumber* MaxQuotAmplitudeBW;
@property (nonatomic, strong) NSNumber* MinEdgeEnergy;

@property (nonatomic, strong) NSString *Base64StrData;
@property (nonatomic, strong) NSString *SoftwareName;
@property (nonatomic, strong) NSString *SoftwareVersion;

- (void) setGPSLatitude: (CGFloat) latitude longitude: (CGFloat) longitude;
- (void) setImage: (UIImage*) image;

- (void) setDetectResult: (DetectResult*) detectResult;
@end
