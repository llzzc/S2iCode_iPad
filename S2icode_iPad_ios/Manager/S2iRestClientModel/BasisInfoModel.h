//
//  BasisInfoModel.h
//  S2iPhone
//
//  Created by Pai Peng on 02/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasisInfoModel : NSObject


@property (nonatomic, strong) NSNumber *ColorCode;

@property (nonatomic, strong) NSString *ColorCodeInfo;
@property (nonatomic, strong) NSString *CompanyName;
@property (nonatomic, strong) NSString *CompanyUrl;
@property (nonatomic, strong) NSString *DataContent;
@property (nonatomic, strong) NSNumber *DogId;
@property (nonatomic, strong) NSString *FromDate;
@property (nonatomic, strong) NSString *ImgQlt;
@property (nonatomic, strong) NSNumber *NanoCount;

@property (nonatomic, strong) NSString *PdtTraceabilityUrl;
@property (nonatomic, strong) NSNumber *PdtUseType;
@property (nonatomic, strong) NSString *ProductUrl;
@property (nonatomic, strong) NSNumber *SerialNo;



@end
