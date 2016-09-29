//
//  S2iRestClient.h
//  S2iPhone
//
//  Created by Pai Peng on 30/06/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RestKit/RestKit.h>
@interface S2iRestClient : NSObject

@property (nonatomic, strong) RKObjectManager *objectManager;


- (void) test;

@end
