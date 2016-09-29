//
//  S2iAddDevInfoModel.h
//  S2iPhone
//
//  Created by txm on 15/4/7.
//  Copyright (c) 2015年 沈阳安创信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  添加AddPhoneDeviceInfo解析模型类
 */
@interface S2iAddDevInfoModel : NSObject


@property (nonatomic, copy) NSString * resultCode;      //结果  说明：0失败 1成功 2已存在
@property (nonatomic, copy) NSString * errorInfo;           //错误信息描述			  说明：信息描述
@property (nonatomic, copy) NSString * phoneDeviceId;   //设备Id              说明：默认0



//快速创建实体类
+ (id)addDevInfoWithResultCode:(NSString *)resultCode
                     errorInfo:(NSString *)errorInfo
                 phoneDeviceId:(NSString *)phoneDeviceId;


@end
