//
//  ClientInitData.m
//  S2iPhone
//
//  Created by Pai Peng on 01/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import "ClientInitData.h"

@implementation ClientInitData

- (id) init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _Data = [[ClientInitDataModel alloc] init];
    return self;
}
@end
