//
//  SoftwareVersionModel.h
//  S2iPhone
//
//  Created by Pai Peng on 01/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoftwareVersionModel : NSObject

// "SoftwareVersion":{"UpdateSite":"","MajorNumber":0,"MinorNumber":0,"RevisionNumber":0,"Description":"","VersionStatus":0,"SHA256":""}

@property (nonatomic, copy) NSString *UpdateSite;
@property (nonatomic, copy) NSNumber *MajorNumber;
@property (nonatomic, copy) NSNumber *MinorNumber;
@property (nonatomic, copy) NSNumber *RevisionNumber;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSNumber *VersionStatus;
@property (nonatomic, copy) NSString *SHA256;


- (NSDictionary*) convertToDictionary;
@end
