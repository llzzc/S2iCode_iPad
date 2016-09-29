//
//  S2iPdtFlowIdDecInfoModel.m
//  S2iPhone
//
//  Created by txm on 15/4/8.
//  Copyright (c) 2015年 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iPdtFlowIdDecInfoModel.h"



@implementation S2iPdtFlowIdDecInfoModel


#pragma mark - 快速创建实体类
+ (id)pdtFlowIdDecInfoId:(NSString *)Id
                 DecTime:(NSString *)DecTime
                      IP:(NSString *)IP
                 Address:(NSString *)Address;
{
    S2iPdtFlowIdDecInfoModel * model = [[self alloc] init];
    
    model.Id = Id;
    model.DecTime = DecTime;
    model.IP = IP;
    model.Address = Address;

    return model;
}


@end
