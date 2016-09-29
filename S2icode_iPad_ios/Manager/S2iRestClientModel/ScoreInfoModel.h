//
//  ScoreInfoModel.h
//  S2iPhone
//
//  Created by Pai Peng on 02/07/16.
//  Copyright © 2016 沈阳安创信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreInfoModel : NSObject


@property (nonatomic, strong) NSNumber *DecLevel;
@property (nonatomic, strong) NSNumber *DecMaxScore;
@property (nonatomic, strong) NSNumber *DecMinScore;
@property (nonatomic, strong) NSString *HistScore;
@property (nonatomic, strong) NSString *QltScore;
@property (nonatomic, strong) NSString *ShapeScore;
@property (nonatomic, strong) NSNumber *TotalScore;

@end
