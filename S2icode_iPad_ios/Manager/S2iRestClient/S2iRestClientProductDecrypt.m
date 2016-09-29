//
//  S2iRestClientProductDecrypt.m
//  S2iPhone
//
//  Created by Pai Peng on 02/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iRestClientProductDecrypt.h"
#import "ScoreInfoModel.h"
#import "ProductDecryptDataModel.h"

@implementation S2iRestClientProductDecrypt

#define REST_URL_PRODUCT_DECRYPT @"/api/v4/ProductDecrypt"


- (void) configureRestKit {
    [super configureRestKit];
    
    // setup object mappings
    RKObjectMapping *productDecryptDataModel = [RKObjectMapping mappingForClass:[ProductDecryptDataModel class]];
    [productDecryptDataModel addAttributeMappingsFromArray:@[@"Code",
                                                           @"Message",
                                                           @"Data"]];
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:productDecryptDataModel
                                                 method:RKRequestMethodPOST
                                            pathPattern: REST_URL_PRODUCT_DECRYPT
                                                keyPath:@"" //@"response.venues"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    
    // setup object mappings
    RKObjectMapping *productDecryptModel = [RKObjectMapping mappingForClass:[ProductDecryptModel class]];
    [productDecryptModel addAttributeMappingsFromArray:@[
                                                         @"ScoreInfo"
                                                         ]];
    
    // register mappings with the provider using a response descriptor
    responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:productDecryptModel
                                                 method:RKRequestMethodPOST
                                            pathPattern:REST_URL_PRODUCT_DECRYPT
                                                keyPath:@"Data"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *scoreInfoModelMapping = [RKObjectMapping mappingForClass:[ScoreInfoModel class]];
    [scoreInfoModelMapping addAttributeMappingsFromArray:@[@"DecLevel",
                                                           @"DecMaxScore",
                                                           @"DecMinScore",
                                                           @"HistScore",
                                                           @"QltScore",
                                                           @"ShapeScore",
                                                           @"TotalScore"
                                                           ]];
    // register mappings with the provider using a response descriptor
    responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:scoreInfoModelMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern: REST_URL_PRODUCT_DECRYPT
                                                keyPath:@"Data.ScoreInfo"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *variableCodeInfoModelMapping = [RKObjectMapping mappingForClass:[VariableCodeInfoModel class]];
    [variableCodeInfoModelMapping addAttributeMappingsFromArray:@[
                                                                  @"CurrentNumber",
                                                                  @"Description",
                                                                  @"SerialNo"
                                                           ]];

    responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:variableCodeInfoModelMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern: REST_URL_PRODUCT_DECRYPT
                                                keyPath:@"Data.VariableCodeInfo"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    
    RKObjectMapping *pdtDecRecordModelMapping = [RKObjectMapping mappingForClass:[PdtDecRecordModel class]];
    [pdtDecRecordModelMapping addAttributeMappingsFromArray:@[
                                                                  @"IP",
                                                                  @"Address",
                                                                  @"Id",
                                                                  @"DecTime"
                                                                  ]];
    
    responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:pdtDecRecordModelMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern: REST_URL_PRODUCT_DECRYPT
                                                keyPath:@"Data.VariableCodeInfo.PdtDecRecordList"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    

    
    
    
    
    
    
    RKObjectMapping *basisInfoModelMapping = [RKObjectMapping mappingForClass:[BasisInfoModel class]];
    [basisInfoModelMapping addAttributeMappingsFromArray:@[
                                                                  @"ColorCode",
                                                                  @"ColorCodeInfo",
                                                                  @"CompanyName",
                                                                  @"CompanyUrl",
                                                                  @"DataContent",
                                                                  @"DogId",
                                                                  @"FromDate",
                                                                  @"ImgQlt",
                                                                  @"NanoCount",
                                                                  @"PdtTraceabilityUrl",
                                                                  @"PdtUseType",
                                                                  @"ProductUrl",
                                                                  @"SerialNo"
                                                                  ]];
    
    responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:basisInfoModelMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern: REST_URL_PRODUCT_DECRYPT
                                                keyPath:@"Data.BasisInfo"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
}

- (void) getProductDecrypt: (RestRequestProductDecryptModel*) requestProductDecrypt withSuccess:(void (^)(ProductDecryptDataModel* productDecryptModel))success withFailure:(void (^)(NSError *error))failure {
    
    __block ProductDecryptDataModel* productDecryptDataModel = [[ProductDecryptDataModel alloc] init];
    [objectManager postObject:productDecryptDataModel
                                           path:REST_URL_PRODUCT_DECRYPT
                                     parameters:[requestProductDecrypt convertToDictionary]
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            S2iLog(@"success");
                                            productDecryptDataModel.Data.ScoreInfo = [mappingResult.dictionary valueForKey:@"Data.ScoreInfo"];
                                            productDecryptDataModel.Data.VariableCodeInfo = [mappingResult.dictionary valueForKey:@"Data.VariableCodeInfo"];
                                            productDecryptDataModel.Data.BasisInfo = [mappingResult.dictionary valueForKey:@"Data.BasisInfo"];
                                            productDecryptDataModel.Data.VariableCodeInfo.PdtDecRecordList = [mappingResult.dictionary valueForKey:@"Data.VariableCodeInfo.PdtDecRecordList"];
                                            success(productDecryptDataModel);
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            S2iLog(@"What do you mean by 'there is no coffee?': %@", error);
                                            failure(error);
                                        }];

}
@end
