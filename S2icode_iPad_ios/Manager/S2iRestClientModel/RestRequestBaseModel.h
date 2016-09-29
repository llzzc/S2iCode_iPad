//
//  RestRequestBaseModel.h
//  S2iPhone
//
//  Created by Pai Peng on 01/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestRequestBaseModel : NSObject

@property (nonatomic, strong) NSString *Password;
@property (nonatomic, strong) NSNumber *LangId;
@property (nonatomic, strong) NSNumber *SystemId;

- (NSDictionary*) convertToDictionary;
@end
