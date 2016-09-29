//
//  SoftwareVersionModel.m
//  S2iPhone
//
//  Created by Pai Peng on 01/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import "SoftwareVersionModel.h"

@implementation SoftwareVersionModel

- (NSDictionary*) convertToDictionary {
    
    return @{
             @"UpdateSite": _UpdateSite,
             @"MajorNumber": _MajorNumber,
             @"MinorNumber": _MinorNumber,
             @"RevisionNumber": _RevisionNumber,
             @"Description": _Description,
             @"VersionStatus": _VersionStatus,
             @"SHA256": _SHA256
             };
}

@end
