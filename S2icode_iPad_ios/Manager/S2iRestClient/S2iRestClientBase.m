//
//  S2iRestClientBase.m
//  S2iPhone
//
//  Created by Pai Peng on 01/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import "S2iRestClientBase.h"


#if DEBUG
#define RK_LOG_LEVEL RKLogLevelTrace
#else
#define RK_LOG_LEVEL RKLogLevelOff
#endif

@implementation S2iRestClientBase




- (id) init {
    S2iLog(@"init");
    RKLogConfigureByName("RestKit/Network*", RK_LOG_LEVEL);
    RKLogConfigureByName("RestKit/ObjectMapping", RK_LOG_LEVEL);
    
    //let AFNetworking manage the activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    [self configureRestKit];
    
    return self;
}

- (void) configureRestKit {
    // initialize AFNetworking HTTPClient
#if TEST_SERVER
    NSURL *baseURL = [NSURL URLWithString:S2I_TEST_WEBSERVICE_URL];
#else
    NSURL *baseURL = [NSURL URLWithString: S2I_WEBSERVICE_URL];
#endif
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    client.allowsInvalidSSLCertificate = YES;
}
@end
