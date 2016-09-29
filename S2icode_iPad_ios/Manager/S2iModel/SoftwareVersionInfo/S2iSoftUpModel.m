//
//  S2iSoftUpModel.m
//  S2iPhone
//
//  Created by txm on 14/12/19.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iSoftUpModel.h"

@implementation S2iSoftUpModel




#pragma mark - 快速创建实体类
/**
 *  快速创建实体类
 */
+ (id)softUpMomdelWithResultCode:(enumSoftUp)enumResultCode
                       errorInfo:(NSString *)errorInfo
                      updateSite:(NSString *)updateSite
              majorVersionNumber:(NSString *)majorVersionNumber
              minorVersionNumber:(NSString *)minorVersionNumber
                 softDescription:(NSString *)softDescription
                   versionStatus:(enumVersionStatus)versionStatus
{
    S2iSoftUpModel * model = [[self alloc] init];
    
    model.enumResultCode = enumResultCode;
    model.errorInfo = errorInfo;
    model.updateSite = updateSite;
    model.majorVersionNumber = majorVersionNumber;
    model.minorVersionNumber = minorVersionNumber;
    model.softDescription = softDescription;
    model.versionStatus = versionStatus;
    
    return model;
}


@end
