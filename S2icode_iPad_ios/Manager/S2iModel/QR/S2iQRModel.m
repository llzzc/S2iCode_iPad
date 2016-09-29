//
//  S2iQRModel.m
//  S2iPhone
//
//  Created by txm on 15/2/3.
//  Copyright (c) 2015年 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iQRModel.h"

@implementation S2iQRModel



//快速创建实体类
//快速创建实体类
+ (id)qrWithImageName:(NSString *)qrImageName
               qrInfo:(NSString *)qrInfo
{
    S2iQRModel * model = [[self alloc] init];
    
    model.qrImageName = qrImageName;
    model.qrInfo = qrInfo;
    
    return model;
}





#pragma mark - 调试方式
- (NSString *)description
{
    return [NSString stringWithFormat:@" \
            < S2iQRModel:%p \
            qrImageName:(%@) \
            qrInfo:(%@)>",
            self,
            _qrImageName,
            _qrInfo];
}




@end
