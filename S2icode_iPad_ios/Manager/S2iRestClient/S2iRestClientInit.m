//
//  S2iRestClientInit.m
//  S2iPhone
//
//  Created by Pai Peng on 01/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iRestClientInit.h"
#import "ClientInit.h"
#import "ClientInitData.h"
#import "RestRequestClientInit.h"

#define REST_URL @"/api/v4/ClientInit"

@implementation S2iRestClientInit

- (void) configureRestKit {
    [super configureRestKit];
    
    // setup object mappings
    RKObjectMapping *clientInitDataMapping = [RKObjectMapping mappingForClass:[ClientInitData class]];
    [clientInitDataMapping addAttributeMappingsFromArray:@[@"Code",
                                                           @"Message",
                                                           @"Data"]];
    
    
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:clientInitDataMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern: REST_URL
                                                keyPath:@"" //@"response.venues"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    
        // QRWhiteUrls
    //RKObjectMapping *qrWhiteUrlsMapping = [RKObjectMapping mappingForClass:[NSSet class]];
#if 0
    [clientInitDataMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"QRWhiteUrls"
                                                                                    toKeyPath:@"Data.QRWhiteUrls"]];
    
    responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:qrWhiteUrlsMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:REST_URL
                                                keyPath:@"Data.QRWhiteUrls"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    
    [objectManager addResponseDescriptor:responseDescriptor];
#endif

    
    //
    RKObjectMapping *softwareVersionModelMapping = [RKObjectMapping mappingForClass:[SoftwareVersionModel class]];
    [softwareVersionModelMapping addAttributeMappingsFromArray:@[@"UpdateSite",
                                                                 @"MajorNumber",
                                                                 @"MinorNumber",
                                                                 @"RevisionNumber",
                                                                 @"VersionStatus",
                                                                 @"Description",
                                                                 @"SHA256"
                                                                 ]];
#if 1
    // register mappings with the provider using a response descriptor
    responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:softwareVersionModelMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:REST_URL
                                                keyPath:@"Data.SoftwareVersion"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    
    [objectManager addResponseDescriptor:responseDescriptor];
#endif
    
    RKObjectMapping *deviceConfigInfoModelMapping = [RKObjectMapping mappingForClass:[DeviceConfigInfoModel class]];
    [deviceConfigInfoModelMapping addAttributeMappingsFromArray:@[@"AutoFocusTimeInterval",
                                                                  @"AutoPhotoMinTimeInterval",
                                                                  @"DPI2000FocusBoxHeight",
                                                                  @"DPI2000FocusBoxWidth",
                                                                  @"DPI2000RangeMax",
                                                                  @"DPI2000RangeMin",
                                                                  @"DPI800FocusBoxHeight",
                                                                  @"DPI800FocusBoxWidth",
                                                                  @"DPI800RangeMax",
                                                                  @"DPI800RangeMin",
                                                                  @"DetectCropImageHeightScale",
                                                                  @"DetectCropImageWidthScale",
                                                                  @"DeviceId",
                                                                  @"DisableDecode",
                                                                  @"EMetricThreshold",
                                                                  @"FocusMode",
                                                                  @"ForceLogin",
                                                                  @"JpegCompress",
                                                                  @"MaxQuotAmplitudeBW",
                                                                  @"MinDiffBW",
                                                                  @"MinDistToThreshold",
                                                                  @"MinEdgeEnergy",
                                                                  @"PhotoSizeHeight",
                                                                  @"PhotoSizeWidth",
                                                                  @"PositionErrorMargin",
                                                                  @"PreviewSizeHeight",
                                                                  @"PreviewSizeWidth",
                                                                  @"ReflectDiff",
                                                                  @"S2iPicBorder",
                                                                  @"S2iPicHeight",
                                                                  @"S2iPicWidth",
                                                                  @"ThumbnailImageHeight",
                                                                  @"ThumbnailImageJpegCompress",
                                                                  @"ThumbnailImageWidth",
                                                                  @"UploadFullImageThumbnail",
                                                                  @"Zoom",
                                                                  @"MinZoom",
                                                                  @"MaxZoom"
                                                                  ]];
    
    // register mappings with the provider using a response descriptor
    responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:deviceConfigInfoModelMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:REST_URL
                                                keyPath:@"Data.DeviceConfigInfo"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    

    
    
    // setup object mappings
    RKObjectMapping *slidePictureModelMapping = [RKObjectMapping mappingForClass:[SlidePictureModel class]];
    [slidePictureModelMapping addAttributeMappingsFromArray:@[@"Name",
                                                              @"Date",
                                                              @"Href",
                                                              @"Id",
                                                              @"Sort",
                                                              @"Src"]];
    
    // register mappings with the provider using a response descriptor
    responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:slidePictureModelMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:REST_URL
                                                keyPath:@"Data.SlidePictures"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    
    
    // setup object mappings
    RKObjectMapping *clientInitDataModelMapping = [RKObjectMapping mappingForClass:[ClientInitDataModel class]];
    [clientInitDataModelMapping addAttributeMappingsFromArray:@[@"DeviceConfigInfo",
                                                                @"QRWhiteUrls"]];
    
    // register mappings with the provider using a response descriptor
    responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:clientInitDataModelMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:REST_URL
                                                keyPath:@"Data"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
#if 0
    // Define the relationship mapping
    [clientInitDataModelMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"SoftwareVersion"
                                                                                   toKeyPath:@"SoftwareVersion"
                                                                                 withMapping:softwareVersionModelMapping]];
#endif
    
    
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    
    

    
}

- (void) getClientInit: (RestRequestClientInit*) requestClientInit withSuccess:(void (^)(ClientInitData* ClientInitData))success withFailure:(void (^)(NSError *error))failure {
    __block ClientInitData* clientData = [[ClientInitData alloc] init];
    [objectManager postObject:clientData
                                           path:REST_URL
                                     parameters:[requestClientInit convertToDictionary]
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            clientData.Data.DeviceConfigInfo = [mappingResult.dictionary valueForKey:@"Data.DeviceConfigInfo"];
                                            clientData.Data.SoftwareVersion = [mappingResult.dictionary valueForKey:@"Data.SoftwareVersion"];
                                            clientData.Data.SlidePictures = [mappingResult.dictionary valueForKey:@"Data.SlidePictures"];
                                            clientData.Data.QRWhiteUrls = [[mappingResult.dictionary valueForKey:@"Data"] valueForKey:@"QRWhiteUrls"];
                                            S2iLog(@"response %@", [clientData description]);
                                            success(clientData);
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            S2iLog(@"What do you mean by 'there is no coffee?': %@", error);
                                            failure(error);
                                        }];
}

@end
