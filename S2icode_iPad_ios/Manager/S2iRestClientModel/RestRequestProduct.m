//
//  RestRequestProduct.m
//  S2iPhone
//
//  Created by txm on 16/7/12.
//  Copyright © 2016年 沈阳安创信息科技有限公司. All rights reserved.
//

#import "RestRequestProduct.h"

@implementation RestRequestProduct




- (NSDictionary*) convertToDictionary {
    NSMutableDictionary* d = [[NSMutableDictionary alloc] initWithDictionary:[super convertToDictionary]];
    [d addEntriesFromDictionary: @{
                                   @"SerialNumber": _SerialNumber // @"1"
                                   }];
    return d;
}
@end