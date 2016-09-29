//
//  SerialNoModel.h
//  S2iPhone
//
//  Created by wangxin on 15/12/7.
//  Copyright © 2015年 沈阳安创信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SerialNoModel : NSObject


//全球唯一序号
@property (nonatomic, copy) NSString * SerialNO;
//公司名称
@property (nonatomic, copy) NSString * CompanyName;
//认证日期
@property (nonatomic, copy) NSString * CreateDate;
//防伪码内容
@property (nonatomic, copy) NSString * SignetData;
//使用类型 (0.一批一码 1.一标一码)
@property (nonatomic, copy) NSString * PdtUseType;



//快速创建实体类
+ (id)SerialNoWithNo:(NSString *)SerialNO
         CompanyName:(NSString *)CompanyName
          CreateDate:(NSString *)CreateDate
          SignetData:(NSString *)SignetData
          PdtUseType:(NSString *)PdtUseType;


@end
