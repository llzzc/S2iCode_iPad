//
//  ClientInitDataModel.m
//  S2iPhone
//
//  Created by Pai Peng on 01/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import "ClientInitDataModel.h"

@implementation ClientInitDataModel

- (id) init {
    self = [super init];
    if (!self) {
        return nil;
    }
    //_DeviceConfigInfo = [[DeviceConfigInfoModel alloc] init];
    return self;
}


- (NSDictionary*) convertToDictionary {
    
    NSMutableArray* slidePicutresArray = [[NSMutableArray alloc] init];
    
    if (_SlidePictures) {
        for(SlidePictureModel* slidePicture in _SlidePictures) {
            [slidePicutresArray addObject:[slidePicture convertToDictionary]];
        }
    }
    
    
    
    return @{
      @"SlidePictures": slidePicutresArray,
      @"QRWhiteUrls": _QRWhiteUrls?_QRWhiteUrls:[[NSArray alloc]init],
      @"DeviceConfigInfo": [_DeviceConfigInfo convertToDictionary],
      @"SoftwareVersion": [_SoftwareVersion convertToDictionary]
      };
}
@end
