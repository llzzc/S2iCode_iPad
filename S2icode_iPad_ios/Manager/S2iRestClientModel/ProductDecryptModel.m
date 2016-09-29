//
//  ProductDecryptModel.m
//  S2iPhone
//
//  Created by Pai Peng on 02/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import "ProductDecryptModel.h"

@implementation ProductDecryptModel


- (S2iDecPdtModel*) convertToS2iDecPdtModel {
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    
    NSString* recordList = @"";
    
    if (_VariableCodeInfo.PdtDecRecordList && _VariableCodeInfo.PdtDecRecordList.count > 0) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        for (int i = 0; i < _VariableCodeInfo.PdtDecRecordList.count; i++) {
            NSDictionary *queryParams = @{@"IP": _VariableCodeInfo.PdtDecRecordList[i].IP,
                                          @"Address": _VariableCodeInfo.PdtDecRecordList[i].Address,
                                          @"Id": _VariableCodeInfo.PdtDecRecordList[i].Id,
                                          @"DecTime": _VariableCodeInfo.PdtDecRecordList[i].DecTime
                                          };
            [array addObject:queryParams];
        }
        NSError* error = nil;
        NSData *jsd = [NSJSONSerialization dataWithJSONObject:array options: 0 error:&error];
        recordList = [[NSString alloc] initWithData:jsd encoding:NSUTF8StringEncoding];
        
    }
    
    numberFormatter.minimumIntegerDigits = 16;
    NSString *sn = (([_BasisInfo.PdtUseType integerValue] == 1)? _VariableCodeInfo.SerialNo:[numberFormatter stringFromNumber:_BasisInfo.SerialNo]);
    numberFormatter.minimumIntegerDigits = 0;
    
    S2iDecPdtModel* decPdtModel = [S2iDecPdtModel
                                   decPdtWithId:0
                                   decImageName:@""
                                   fromDate:_BasisInfo.FromDate
                                   // 一标一码使用 VariableCodeInfo 里的序列号保存显示
                                   serialNo: sn
                                   companyName:_BasisInfo.CompanyName
                                   dataContent:_BasisInfo.DataContent
                                   dogId:[numberFormatter stringFromNumber:_BasisInfo.DogId]
                                   imgQlt:_BasisInfo.ImgQlt
                                   nanoCount:[numberFormatter stringFromNumber:_BasisInfo.NanoCount]
                                   companyUrl:_BasisInfo.CompanyUrl
                                   productUrl:_BasisInfo.ProductUrl
                                   pdtUseType:[numberFormatter stringFromNumber:_BasisInfo.PdtUseType]
                                   pdtTraceabilityUrl:_BasisInfo.PdtTraceabilityUrl
                                   colorCode:[numberFormatter stringFromNumber:_BasisInfo.ColorCode]
                                   colorCodeInfo:_BasisInfo.ColorCodeInfo
                                   shapeScore:_ScoreInfo.ShapeScore
                                   histScore:_ScoreInfo.HistScore
                                   qltScore:_ScoreInfo.QltScore
                                   totalScore:[numberFormatter stringFromNumber:_ScoreInfo.TotalScore]
                                   maxDecScore:[numberFormatter stringFromNumber:_ScoreInfo.DecMaxScore]
                                   minDecScore:[numberFormatter stringFromNumber:_ScoreInfo.DecMinScore]
                                   decLevel:[numberFormatter stringFromNumber:_ScoreInfo.DecLevel]
                                   currentNumber:_VariableCodeInfo.CurrentNumber
                                   descriptionStr:_VariableCodeInfo.Description
                                   pdtDecRecordList:recordList // todo
                                   ];
    
    return decPdtModel;
}
@end
