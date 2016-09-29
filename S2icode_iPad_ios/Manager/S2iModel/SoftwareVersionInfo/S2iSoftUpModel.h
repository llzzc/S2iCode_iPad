//
//  S2iSoftUpModel.h
//  S2iPhone
//
//  Created by txm on 14/12/19.
//  Copyright (c) 2014年 沈阳安创信息科技有限公司. All rights reserved.
/*
    描述：软件版本更新模型类
 */

#import <Foundation/Foundation.h>


/**
 *  软件升级版本状态
 */
typedef enum
{
    ENUM_VERSION_STATES_USABLE = 0,     //可用
    ENUM_VERSION_STATES_UPDATE = 1      //不可用，强制更新
    
}enumVersionStatus;


/**
 *  解码状态枚举
 */
typedef enum
{
    ENUM_SOFTUP_FAILURE = 0,       //失败
    ENUM_SOFTUP_SUCCESS = 1,       //成功
    ENUM_SOFTUP_EXIST = 2          //已存在
}enumSoftUp;




@interface S2iSoftUpModel : NSObject


@property (nonatomic, assign) enumSoftUp enumResultCode;            //结果：0失败 1成功 2已存在
@property (nonatomic, copy) NSString * errorInfo;                   //错误信息描述
@property (nonatomic, copy) NSString * updateSite;                  //下载地址
@property (nonatomic, copy) NSString * majorVersionNumber;               //主版本号
@property (nonatomic, copy) NSString * minorVersionNumber;                 //副版本号
@property (nonatomic, copy) NSString * softDescription;             //版本说明
@property (nonatomic, assign) enumVersionStatus versionStatus;      //上一个版本 0可用 1不可 必须下载





/**
 *  快速创建实体类
 */
+ (id)softUpMomdelWithResultCode:(enumSoftUp)enumResultCode
                       errorInfo:(NSString *)errorInfo
                      updateSite:(NSString *)updateSite
             majorVersionNumber:(NSString *)majorVersionNumber
               minorVersionNumber:(NSString *)minorVersionNumber
            softDescription:(NSString *)softDescription
             versionStatus:(enumVersionStatus)versionStatus;










@end
