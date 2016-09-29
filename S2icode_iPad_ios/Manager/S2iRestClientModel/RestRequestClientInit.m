//
//  RestRequestClientInit.m
//  S2iPhone
//
//  Created by Pai Peng on 01/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import "RestRequestClientInit.h"

@implementation RestRequestClientInit

- (id) init {
    self = [super init];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *bundleIdentifierKey = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
    
    
    NSString* deviceType = [S2iTool S2iCurrentPhoneType];
    
    
    _SystemVersion = version;
    _UDID = [S2iConfig sharedS2iConfig].UUID;
    _SoftwareName = bundleIdentifierKey;
    _DeviceType = deviceType;
    return self;
}


- (NSDictionary*) convertToDictionary {
    NSMutableDictionary* d = [[NSMutableDictionary alloc] initWithDictionary:[super convertToDictionary]];
    [d addEntriesFromDictionary: @{
                                  @"SystemVersion": _SystemVersion, // @"1",
                                  @"DeviceType": _DeviceType, // @"IPHONE6",
                                  @"UDID": _UDID, // @"11111",
                                  @"SoftwareName": _SoftwareName // @"iPhone"
                                  }];
    return d;
}
@end
