//
//  S2iRestProduct.m
//  S2iPhone
//
//  Created by txm on 16/7/12.
//  Copyright © 2016年 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iRestProduct.h"
#import "ProductInfoData.h"
#import "ProductInfoModel.h"


@implementation S2iRestProduct

#define REST_URL_PRODUCT_INFO @"/api/v4/ProductInfo"


- (void) configureRestKit {
    [super configureRestKit];
    
    // setup object mappings
    RKObjectMapping *productInfoDataMapping = [RKObjectMapping mappingForClass:[ProductInfoData class]];
    [productInfoDataMapping addAttributeMappingsFromArray:@[@"Code",
                                                           @"Message",
                                                           @"Data"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:productInfoDataMapping
                                                 method:RKRequestMethodGET
                                            pathPattern: REST_URL_PRODUCT_INFO
                                                keyPath:@"" //@"response.venues"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];

    
    RKObjectMapping *productInfoModelMapping = [RKObjectMapping mappingForClass:[ProductInfoModel class]];
    [productInfoModelMapping addAttributeMappingsFromArray:@[@"CompanyName",
                                                           @"CreateDate",
                                                           @"PdtUseType",
                                                           @"SerialNumber",
                                                           @"SignetData"
                                                           ]];
    // register mappings with the provider using a response descriptor
    responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:productInfoModelMapping
                                                 method:RKRequestMethodGET
                                            pathPattern: REST_URL_PRODUCT_INFO
                                                keyPath:@"Data"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
}

- (void) getProduct: (RestRequestProduct*) requestProduct withSuccess:(void (^)(ProductInfoModel* productInfoModel))success withFailure:(void (^)(NSError *error))failure {
    
    __block ProductInfoData* productInfoData = [[ProductInfoData alloc] init];
    [objectManager getObject:productInfoData
                         path:REST_URL_PRODUCT_INFO
                   parameters:[requestProduct convertToDictionary]
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          if ([productInfoData.Code integerValue] == 10000) {
                              S2iLog(@"success");
                              productInfoData.Data = [mappingResult.dictionary valueForKey:@"Data"];
                              success(productInfoData.Data);
                          } else {
                              failure(nil);
                          }
                      }
                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          S2iLog(@"What do you mean by 'there is no coffee?': %@", error);
                          failure(error);
    }];
    
}

@end