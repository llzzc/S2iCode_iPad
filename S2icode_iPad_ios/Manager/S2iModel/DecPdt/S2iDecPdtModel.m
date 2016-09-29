//
//  S2iDecPdtModel.m
//  S2iPhone
//
//  Created by txm on 14/12/19.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
/*
    描述：小章解码接口实体类
 */

#import "S2iDecPdtModel.h"

@implementation S2iDecPdtModel


#pragma mark - 快速创建实体类
+ (id)decPdtWithId:(NSInteger)nId
      decImageName:(NSString *)decImageName
          fromDate:(NSString *)fromDate
          serialNo:(NSString *)serialNo
       companyName:(NSString *)companyName
       dataContent:(NSString *)dataContent
             dogId:(NSString *)dogId
            imgQlt:(NSString *)imgQlt
         nanoCount:(NSString *)nanoCount
        companyUrl:(NSString *)companyUrl
        productUrl:(NSString *)productUrl
        pdtUseType:(NSString *)pdtUseType
pdtTraceabilityUrl:(NSString *)pdtTraceabilityUrl
         colorCode:(NSString *)colorCode
     colorCodeInfo:(NSString *)colorCodeInfo
        shapeScore:(NSString *)shapeScore
         histScore:(NSString *)histScore
          qltScore:(NSString *)qltScore
        totalScore:(NSString *)totalScore
       maxDecScore:(NSString *)maxDecScore
       minDecScore:(NSString *)minDecScore
          decLevel:(NSString *)decLevel
     currentNumber:(NSString *)currentNumber
       descriptionStr:(NSString *)descriptionStr
  pdtDecRecordList:(NSString *)pdtDecRecordList
{
    S2iDecPdtModel * model = [[self alloc] init];
    
    model.nId = nId;
    model.decImageName = decImageName;
    
    
    model.fromDate = fromDate;
    model.serialNo = serialNo;
    model.companyName = companyName;
    model.dataContent = dataContent;
    model.dogId = dogId;
    model.imgQlt = imgQlt;
    model.nanoCount = nanoCount;
    model.companyUrl = companyUrl;
    model.productUrl = productUrl;
    
    model.pdtUseType = pdtUseType;
    model.pdtTraceabilityUrl = pdtTraceabilityUrl;
    model.colorCode = colorCode;
    model.colorCodeInfo = colorCodeInfo;
    
    model.shapeScore = shapeScore;
    model.qltScore = qltScore;
    model.histScore = histScore;
    model.totalScore = totalScore;
    model.maxDecScore = maxDecScore;
    model.minDecScore = minDecScore;
    model.decLevel = decLevel;
    
    model.currentNumber = currentNumber;
    model.descriptionStr = descriptionStr;
    model.pdtDecRecordList = pdtDecRecordList;
    
    return model;
}





@end
