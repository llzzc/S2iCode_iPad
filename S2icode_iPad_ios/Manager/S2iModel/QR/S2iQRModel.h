//
//  S2iQRModel.h
//  S2iPhone
//
//  Created by txm on 15/2/3.
//  Copyright (c) 2015年 沈阳安创信息科技有限公司. All rights reserved.
/*
    描述：QR表的实体类
 */

#import <Foundation/Foundation.h>

@interface S2iQRModel : NSObject

//@property (nonatomic, assign) NSInteger nId;                //数据库中的主键ID
@property (nonatomic, copy) NSString * qrImageName;        //QR解码图像名称
@property (nonatomic, copy) NSString * qrInfo;             //QR解码信息





//快速创建实体类
+ (id)qrWithImageName:(NSString *)qrImageName
               qrInfo:(NSString *)qrInfo;


@end
