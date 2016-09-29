//
//  S2iPdtFlowIdModel.h
//  S2iPhone
//
//  Created by txm on 15/4/8.
//  Copyright (c) 2015年 沈阳安创信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "S2iPdtFlowIdDecInfoModel.h"


/**
 *  一标一码，对应的数据模型类
 */
@interface S2iPdtFlowIdModel : NSObject




@property (nonatomic, copy) NSString * currentNumber;       //当前解码次数
@property (nonatomic, copy) NSString * strDescription;      //真对解码次数文字描述
@property (nonatomic, strong) NSString * listInfo;    //集合


//快速创建实体类
+ (id)pdtFlowIdWitCurrentNumber:(NSString *)currentNumber
               strDescription:(NSString *)strDescription
                     listInfo:(NSString *)listInfo;






@end
