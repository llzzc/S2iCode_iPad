//
//  S2iRestProduct.h
//  S2iPhone
//
//  Created by txm on 16/7/12.
//  Copyright © 2016年 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iRestClientBase.h"
#import "RestRequestProduct.h"
#import "ProductInfoModel.h"
#import "S2iRestProduct.h"

@interface  S2iRestProduct : S2iRestClientBase

- (void) getProduct: (RestRequestProduct*) requestProduct withSuccess:(void (^)(ProductInfoModel* productInfoModel))success withFailure:(void (^)(NSError *error))failure;



@end

