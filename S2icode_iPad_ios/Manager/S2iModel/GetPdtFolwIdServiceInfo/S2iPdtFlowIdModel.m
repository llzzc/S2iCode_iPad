//
//  S2iPdtFlowIdModel.m
//  S2iPhone
//
//  Created by txm on 15/4/8.
//  Copyright (c) 2015年 沈阳安创信息科技有限公司. All rights reserved.
//



#import "S2iPdtFlowIdModel.h"

@implementation S2iPdtFlowIdModel

+ (id)pdtFlowIdWitCurrentNumber:(NSString *)currentNumber
                 strDescription:(NSString *)strDescription
                       listInfo:(NSString *)listInfo;
{
    S2iPdtFlowIdModel * model = [[self alloc] init];
    
    model.currentNumber = currentNumber;
    model.strDescription = strDescription;
    model.listInfo = listInfo;
    
    return model;
}


@end
