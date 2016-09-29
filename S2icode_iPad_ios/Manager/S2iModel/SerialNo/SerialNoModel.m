//
//  SerialNoModel.m
//  S2iPhone
//
//  Created by wangxin on 15/12/7.
//  Copyright © 2015年 沈阳安创信息科技有限公司. All rights reserved.
//

#import "SerialNoModel.h"

@implementation SerialNoModel


//快速创建实体类
+ (id)SerialNoWithNo:(NSString *)SerialNO
         CompanyName:(NSString *)CompanyName
          CreateDate:(NSString *)CreateDate
          SignetData:(NSString *)SignetData
          PdtUseType:(NSString *)PdtUseType;
{
    SerialNoModel * model = [[self alloc] init];
    
    model.SerialNO = SerialNO;
    model.CompanyName = CompanyName;
    model.CreateDate = CreateDate;
    model.SignetData = SignetData;
    model.PdtUseType = PdtUseType;
    return model;

}

@end
