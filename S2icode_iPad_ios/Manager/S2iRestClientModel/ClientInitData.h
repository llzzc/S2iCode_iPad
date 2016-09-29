//
//  ClientInitData.h
//  S2iPhone
//
//  Created by Pai Peng on 01/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "ClientInitDataModel.h"

@interface ClientInitData : BaseModel

@property (nonatomic, strong) ClientInitDataModel *Data;
@end
