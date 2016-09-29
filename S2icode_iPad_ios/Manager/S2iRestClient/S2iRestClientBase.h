//
//  S2iRestClientBase.h
//  S2iPhone
//
//  Created by Pai Peng on 01/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RestKit/RestKit.h>


@interface S2iRestClientBase : NSObject {
    RKObjectManager *objectManager;
}

- (void) configureRestKit;


@end
