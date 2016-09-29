//
//  S2iRestClient.m
//  S2iPhone
//
//  Created by Pai Peng on 30/06/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iRestClient.h"
#import "ClientInit.h"
#import "ClientInitData.h"

@interface S2iRestClient () {
    NSArray *_statuses;
}

@end

@implementation S2iRestClient





- (id) init {
    S2iLog(@"init");
    
    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    //let AFNetworking manage the activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
#if 0
    // Initialize HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://svc.s2icode.com"];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // HACK: Set User-Agent to Mac OS X so that Twitter will let us access the Timeline
    [client setDefaultHeader:@"User-Agent" value:[NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]]];
    
    //we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    // Initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];


    // Setup our object mappings
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[ClientInit class]];
    [userMapping addAttributeMappingsFromDictionary:@{
                                                      @"Password" : @"Password",
                                                      @"LangId" : @"LangId",
                                                      @"SystemId" : @"SystemId",
                                                      @"SystemVersion" : @"SystemVersion",
                                                      @"DeviceType" : @"DeviceType",
                                                      @"UDID" : @"UDID"
                                                      }];
#if 0
    RKObjectMapping *statusMapping = [RKObjectMapping mappingForClass:[RKTweet class]];
    [statusMapping addAttributeMappingsFromDictionary:@{
                                                        @"id" : @"statusID",
                                                        @"created_at" : @"createdAt",
                                                        @"text" : @"text",
                                                        @"url" : @"urlString",
                                                        @"in_reply_to_screen_name" : @"inReplyToScreenName",
                                                        @"favorited" : @"isFavorited",
                                                        }];
    RKRelationshipMapping* relationShipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                                             toKeyPath:@"user"
                                                                                           withMapping:userMapping];
    [statusMapping addPropertyMapping:relationShipMapping];
    // Update date format so that we can parse Twitter dates properly
    // Wed Sep 29 15:31:08 +0000 2010
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [[RKValueTransformer defaultValueTransformer] insertValueTransformer:dateFormatter atIndex:0];
    
    // Register our mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:statusMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:@"/api/ClientInit"
                                                                                           keyPath:nil
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
#endif
    
#else
    [self configureRestKit];
#endif
    
    return self;
}

- (void) configureRestKit {
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://svc.s2icode.com"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *clientInitDataMapping = [RKObjectMapping mappingForClass:[ClientInitData class]];
    [clientInitDataMapping addAttributeMappingsFromArray:@[@"Code", @"Message", @"Data"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:clientInitDataMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:@"/api/ClientInit"
                                                keyPath:@"" //@"response.venues"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    #if 1
    
    RKObjectMapping *softwareVersionModelMapping = [RKObjectMapping mappingForClass:[SoftwareVersionModel class]];
    [softwareVersionModelMapping addAttributeMappingsFromArray:@[@"UpdateSite", @"MajorNumber", @"MinorNumber"]];
    
    // register mappings with the provider using a response descriptor
    responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:softwareVersionModelMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:@"/api/ClientInit"
                                                keyPath:@"Data.SoftwareVersion"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    
    //[objectManager addResponseDescriptor:responseDescriptor];
#endif
    
    
    RKObjectMapping *deviceConfigInfoModelMapping = [RKObjectMapping mappingForClass:[DeviceConfigInfoModel class]];
    [deviceConfigInfoModelMapping addAttributeMappingsFromArray:@[@"AutoFocusTimeInterval", @"AutoPhotoMinTimeInterval", @"DPI2000FocusBoxHeight"]];
    
    // register mappings with the provider using a response descriptor
    responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:deviceConfigInfoModelMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:@"/api/ClientInit"
                                                keyPath:@"Data.DeviceConfigInfo"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];

    //[objectManager addResponseDescriptor:responseDescriptor];
    
    
    
    // setup object mappings
    RKObjectMapping *clientInitDataModelMapping = [RKObjectMapping mappingForClass:[ClientInitDataModel class]];
    [clientInitDataModelMapping addAttributeMappingsFromArray:@[@"DeviceConfigInfo"]];
    
    // register mappings with the provider using a response descriptor
    responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:clientInitDataModelMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:@"/api/ClientInit"
                                                keyPath:@"Data"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    //[objectManager addResponseDescriptor:responseDescriptor];
    
    
    
    
    
    
    // setup object mappings
    RKObjectMapping *slidePictureModelMapping = [RKObjectMapping mappingForClass:[SlidePictureModel class]];
    [clientInitDataModelMapping addAttributeMappingsFromArray:@[@"Name", @"Date", @"Href", @"Id", @"Sort", @"Src"]];
    
    // register mappings with the provider using a response descriptor
    responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:slidePictureModelMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:@"/api/ClientInit"
                                                keyPath:@"Data.SlidePictures"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];

}

- (void) test {
#if !OEM
    NSString* password = @"8624c9db-7849-4f79-a063-8d658b8f84a0";
#else
    NSString* password = @"9f6b4d64-481e-4ea5-b901-2d4e476ac7a4";
#endif
    NSDictionary *queryParams = @{@"Password": password,
                                  @"LangId": @"1",
                                  @"SystemId": @"1",
                                  @"SystemVersion": @"1",
                                  @"DeviceType": @"IPHONE6",
                                  @"UDID": @"11111",
                                  @"SoftwareName": @"iPhone"
                                  };
    __block ClientInitData* clientData = [[ClientInitData alloc] init];
    [[RKObjectManager sharedManager] postObject:clientData
                                           path:@"/api/ClientInit"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  //_venues = mappingResult.array;
                                                  //[self.tableView reloadData];
                                                  //clientData = mappingResult.firstObject;
                                                  DeviceConfigInfoModel* d = mappingResult.firstObject;
                                                  d = [mappingResult.dictionary valueForKey:@"Data.DeviceConfigInfo"];
                                                  clientData.Data.DeviceConfigInfo = [mappingResult.dictionary valueForKey:@"Data.DeviceConfigInfo"];
                                                  clientData.Data.SoftwareVersion = [mappingResult.dictionary valueForKey:@"Data.SoftwareVersion"];
                                                  S2iLog(@"response %@", [clientData description]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  S2iLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
}

@end
