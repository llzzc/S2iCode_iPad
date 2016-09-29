//
//  S2iRestClientProductDecrypt.h
//  S2iPhone
//
//  Created by Pai Peng on 02/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iRestClientBase.h"

#import "RestRequestProductDecryptModel.h"
#import "ProductDecryptDataModel.h"

@interface S2iRestClientProductDecrypt : S2iRestClientBase


- (void) getProductDecrypt: (RestRequestProductDecryptModel*) requestProductDecrypt withSuccess:(void (^)(ProductDecryptDataModel* productDecryptModel))success withFailure:(void (^)(NSError *error))failure;
@end
