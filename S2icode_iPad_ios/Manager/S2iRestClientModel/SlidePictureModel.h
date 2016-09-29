//
//  SlidePictureModel.h
//  S2iPhone
//
//  Created by Pai Peng on 01/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlidePictureModel : NSObject

@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, strong) NSNumber *Name;
@property (nonatomic, strong) NSString *Src;
@property (nonatomic, strong) NSString *Href;
@property (nonatomic, strong) NSNumber *Sort;
@property (nonatomic, strong) NSNumber *Date;


- (NSDictionary*) convertToDictionary;
@end
