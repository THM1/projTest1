//
//  Link.m
//  projTest1
//
//  Created by THM on 7/13/13.
//  Copyright (c) 2013 THM. All rights reserved.
//

#import "Link.h"

@implementation Link

-(Link *) initWithPrev:(Stage *)prev andNext:(Stage *)next andKeys:(NSArray *)keys andPValues:(NSArray *)pVals andOddsRatios:(NSArray *)oddsRatios
{
    self = [super init];
    
    if([keys count] != [pVals count] || [keys count] != [oddsRatios count]){
        NSLog(@"Error: the number of keys does not match the number of pvalues or oddsratios provided");
        return nil;
    }
    
    if(self){
        [self setPreviousStage:prev];
        [self setNextStage:next];
        
        for(int i=0; i<[keys count]; i++){
            [self setPValueWithKey:[keys objectAtIndex:i] andNewValue:[pVals objectAtIndex:i]];
            [self setOddsRatioWithKey:[keys objectAtIndex:i] andNewRatio:[oddsRatios objectAtIndex:i]];
        }
        
    }
    
    return self;
}

-(Link *) initWithPrev:(Stage *)prev andNext:(Stage *)next andKeys:(NSArray *)keys andFactors:(NSArray *)factorsAtStage
{
    if([keys count] != [factorsAtStage count]){
        NSLog(@"Error: the number of keys does not match the number of pvalues or oddsratios provided");
        return nil;
    }
    
    self = [super init];
    
    if(self){
        
        [self setPreviousStage:prev];
        [self setNextStage:next];
        [self setPosition];
        
        for(int i=0; i<[keys count]; i++){
            [self setFactorAtStageWithKey:[keys objectAtIndex:i] andNewFactor:[factorsAtStage objectAtIndex:i]];
        }
        
    }
    
    return self;
}

-(void)setPosition
{
    float prevPos[3], nextPos[3];
    
    [_prev getPos:prevPos];
    [_next getPos:nextPos];
    
    // midway between previous and next stage positions
    for(int i=0; i<3; i++){
        _pos[i] = (prevPos[i] + nextPos[i]) * 0.5;
    }
    
}

-(void)setPreviousStage:(Stage *)prev
{
    _prev = prev;
}

-(void)setNextStage:(Stage *)next
{
    _next = next;
}

-(void)setPValueWithKey:(NSString *)key andNewValue:(NSString *)newValue
{
    [_pValues setObject:newValue forKey:key];
}

-(void)setOddsRatioWithKey:(NSString *)key andNewRatio:(NSString *)newRatio
{
    [_oddsRatios setObject:newRatio forKey:key];
}

-(void)setFactorAtStageWithKey:(NSString *)key andNewFactor:(NSObject *)factorAtStage
{
    [_factorsAtStage setObject:factorAtStage forKey:key];
}


-(NSString *)getPValueWithKey:(NSString *)key
{
    NSString* result = [_pValues objectForKey:key];
    return result;
}
                        
-(NSString *)getOddsRatioWithKey:(NSString *)key
{
    NSString* result = [_oddsRatios objectForKey:key];
    return result;
}

-(NSObject *)getFactorAtStageWithKey:(NSString *)key
{
    NSObject *result = [_factorsAtStage objectForKey:key];
    return result;
}

-(void)getPos:(float *)pos
{
    for(int i=0; i<3; i++){
        pos[i] = _pos[i];
    }
}


@end
