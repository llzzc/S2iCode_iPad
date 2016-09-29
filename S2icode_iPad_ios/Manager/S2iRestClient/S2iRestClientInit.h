//
//  S2iRestClientInit.h
//  S2iPhone
//
//  Created by Pai Peng on 01/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "S2iRestClientBase.h"

@class ClientInitData;
@class RestRequestClientInit;

@interface S2iRestClientInit : S2iRestClientBase

- (void) getClientInit: (RestRequestClientInit*) requestClientInit withSuccess:(void (^)(ClientInitData* ClientInitData))success withFailure:(void (^)(NSError *error))failure;

@end
