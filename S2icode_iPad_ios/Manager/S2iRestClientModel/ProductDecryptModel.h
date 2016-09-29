//
//  ProductDecryptModel.h
//  S2iPhone
//
//  Created by Pai Peng on 02/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ScoreInfoModel.h"
#import "VariableCodeInfoModel.h"
#import "BasisInfoModel.h"
#import "S2iDecPdtModel.h"

@interface ProductDecryptModel : NSObject


@property (nonatomic, strong) ScoreInfoModel *ScoreInfo;
@property (nonatomic, strong) VariableCodeInfoModel *VariableCodeInfo;
@property (nonatomic, strong) BasisInfoModel *BasisInfo;

- (S2iDecPdtModel*) convertToS2iDecPdtModel;
@end
