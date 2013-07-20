//
//  Link.h
//  projTest1
//
//  Created by THM on 7/13/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FactorFamily.h"
#import "FactorAtStage.h"
#import "Stage.h"

@interface Link : NSObject{
    Stage *_prev, *_next;
    float _pos[3];
    NSMutableDictionary *_factorsAtStage;
    NSMutableDictionary *_pValues;
    NSMutableDictionary *_oddsRatios;
}

-(Link *) initWithPrev:(Stage *)prev andNext:(Stage *)next andKeys:(NSArray *)keys andPValues:(NSArray *)pVals andOddsRatios:(NSArray *)oddsRatios;

-(Link *) initWithPrev:(Stage *)prev andNext:(Stage *)next andKeys:(NSArray *)keys andFactors:(NSArray *)factorsAtStage;
                                             
-(void)setPValueWithKey:(NSString *)key andNewValue:(NSString *)newValue;
-(void)setOddsRatioWithKey:(NSString *)key andNewRatio:(NSString *)newRatio;
-(void)setFactorAtStageWithKey:(NSString *)key andNewFactor:(NSObject *)factorAtStage;

-(NSString *)getPValueWithKey:(NSString *)key;
-(NSString *)getOddsRatioWithKey:(NSString *)key;
-(NSObject *)getFactorAtStageWithKey:(NSString *)key;

-(void) getPos:(float *)pos;

@end
