//
//  RestRequestClientInit.h
//  S2iPhone
//
//  Created by Pai Peng on 01/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestRequestBaseModel.h"

@interface RestRequestClientInit : RestRequestBaseModel


@property (nonatomic, strong) NSString *SystemVersion;
@property (nonatomic, strong) NSString *DeviceType;
@property (nonatomic, strong) NSString *UDID;
@property (nonatomic, strong) NSString *SoftwareName;

@end
