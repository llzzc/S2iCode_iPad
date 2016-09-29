//
//  ClientInit.h
//  S2iPhone
//
//  Created by Pai Peng on 30/06/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientInit : NSObject
// {"Password": "S2iAdrPdtDecode@s2icode.com", "LangId": 1, "SystemId": 1, "SystemVersion": 1, "DeviceType": "IPHONE6", "UDID": "11111", "SoftwareName": "iPhone"}
@property (nonatomic, copy) NSString *Password;
@property (nonatomic, copy) NSNumber *LangId;
@property (nonatomic, copy) NSNumber *SystemId;
@property (nonatomic, copy) NSNumber *SystemVersion;
@property (nonatomic, copy) NSString *DeviceType;
@property (nonatomic, copy) NSString *UDID;


@end
