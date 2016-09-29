//
//  ProductDecryptDataModel.m
//  S2iPhone
//
//  Created by Pai Peng on 02/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import "ProductDecryptDataModel.h"

@implementation ProductDecryptDataModel


- (id) init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _Data = [[ProductDecryptModel alloc] init];
    return self;
}

@end
