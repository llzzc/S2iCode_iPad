//
//  S2iAddDevInfoModel.m
//  S2iPhone
//
//  Created by txm on 15/4/7.
//  Copyright (c) 2015年 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iAddDevInfoModel.h"

@implementation S2iAddDevInfoModel


+ (id)addDevInfoWithResultCode:(NSString *)resultCode
                     errorInfo:(NSString *)errorInfo
                 phoneDeviceId:(NSString *)phoneDeviceId
{
    S2iAddDevInfoModel * model = [[self alloc] init];
    
    model.resultCode = resultCode;
    model.errorInfo = errorInfo;
    model.phoneDeviceId = phoneDeviceId;
    
    return model;
}


#pragma mark - 调试方式
- (NSString *)description
{
    return [NSString stringWithFormat:@" \
            < S2iAddDevInfoModel:%p \
            resultCode:(%@) \
            resultCode:(%@) \
            resultCode:(%@)>",
            self,
            _resultCode,
            _errorInfo,
            _phoneDeviceId];
}


@end
