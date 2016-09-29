//
//  VariableCodeInfoModel.h
//  S2iPhone
//
//  Created by Pai Peng on 02/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PdtDecRecordModel.h"

@interface VariableCodeInfoModel : NSObject


@property (nonatomic, strong) NSString *CurrentNumber;
@property (nonatomic, strong) NSString *Description;
@property (nonatomic, strong) NSString *SerialNo;
@property (nonatomic, strong) NSArray<PdtDecRecordModel*> *PdtDecRecordList;

@end
