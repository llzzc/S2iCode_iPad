
//
//  RestRequestBaseModel.m
//  S2iPhone
//
//  Created by Pai Peng on 01/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import "RestRequestBaseModel.h"

@implementation RestRequestBaseModel


- (id) init {
    S2iLog(@"init");
    
    self = [super init];
    
#if !OEM
    _Password = @"8624c9db-7849-4f79-a063-8d658b8f84a0";
#else
    _Password = @"9f6b4d64-481e-4ea5-b901-2d4e476ac7a4";
#endif
    
//    _Password = @"S2iIosPdtDecode@S2icode.com";
    _SystemId = [NSNumber numberWithInteger:1];

    
    NSString* language = [[NSUserDefaults standardUserDefaults] objectForKey: AppLanguage];
    NSInteger langId = 0;
    if ([language compare:ChineseFlag] == NSOrderedSame) {
        langId = 1;
    } else {
        langId = 2;
    }
    
    _LangId = [NSNumber numberWithInteger: langId];
    return self;
}

- (NSDictionary*) convertToDictionary {
    NSDictionary *queryParams = @{@"Password": _Password,
                                  @"LangId": _LangId,
                                  @"SystemId": _SystemId
                                  };
    return queryParams;
}
@end
