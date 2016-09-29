//
//  S2iPdtFlowIdDecInfoModel.h
//  S2iPhone
//
//  Created by txm on 15/4/8.
//  Copyright (c) 2015年 沈阳安创信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  一标一码，里面的数据模型
 *
 *     <PdtDecInfo>
 *          <Id>int</Id>
 *          <DecTime>string</DecTime>
 *          <IP>string</IP>
 *          <Address>string</Address>
 *     </PdtDecInfo>
 */
@interface S2iPdtFlowIdDecInfoModel : NSObject


@property (nonatomic, copy) NSString * Id;
@property (nonatomic, copy) NSString * DecTime;
@property (nonatomic, copy) NSString * IP;
@property (nonatomic, copy) NSString * Address;


//快速创建实体类
+ (id)pdtFlowIdDecInfoId:(NSString *)Id
                 DecTime:(NSString *)DecTime
                      IP:(NSString *)IP
                 Address:(NSString *)Address;


@end
