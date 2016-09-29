//
//  SlidePictureModel.m
//  S2iPhone
//
//  Created by Pai Peng on 01/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import "SlidePictureModel.h"

@implementation SlidePictureModel

- (NSDictionary*) convertToDictionary {
    
    return @{
             @"Id": _Id,
             @"Name": _Name,
             @"Src": _Src,
             @"Href": _Href,
             @"Sort": _Sort,
             @"Date": _Date
             };
}
@end
